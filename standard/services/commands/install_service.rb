require "erb"
require "tempfile"

param! :machine
param! :service, default_param: true

allows_extra

run do |plugin, machine, service, params|
  processed = Hash.new { |h,k| h[k] = [] }

  @op.verify_mandatory_params(params)

  $logger.debug "install data : #{service.data["install"]}"
  description = service.data["install"]
  if description.include?(:files)
    if description[:files].include?(:create)
      creates = description[:files][:create]
      creates.each do |what|
        if what.include? :in
          machine.mkdirs(what[:in])
          (what[:dirs] || []).each do |dir|
            machine.mkdirs (File.join(what[:in], dir))
          end
          processed[:create] << what
        end
      end
    end

    if description[:files].include?(:copy)
      copies = description[:files][:copy]
      copies.each do |what|
        unless what.include?(:from) && what.include?(:to)
          raise "copy needs to include :from and :to"
        end

        local_path = File.join(service.plugin.plugin_dir(:files), what[:from])
        unless File.exists? local_path
          raise "file not found at #{local_path}"
        end
        # TODO this does not work if remote_path needs root permissions
        # (and current user is marvin)
        machine.scp_up("local_path" => local_path, "remote_path" => what[:to])
        processed[:copy] << what
      end
    end

    if description[:files].include?(:template)
      templates = description[:files][:template]
      templates.each do |what|
        unless what.include?(:template) && what.include?(:to)
          raise "template needs to include :template and :to"
        end

        template_path = File.join(service.plugin.plugin_dir(:templates), what[:template])
        unless File.exists? template_path
          raise "template not found at #{template_path}"
        end

        tmp = Tempfile.new("vop_service_install_template")
        begin
          # TODO could use more bindings?
          vars = {
            "service" => service,
            "machine" => machine
          }
          @op.machines["localhost"].write_template(
            template: template_path,
            to: tmp.path,
            bind: OpenStruct.new(vars).instance_eval { binding }
          )
          tmp.flush
          $logger.info "template #{what[:template]} processed into #{what[:to]} (using local temp path #{tmp.path})"
          machine.scp_up("local_path" => tmp.path, "remote_path" => what[:to])
          processed[:template] << what
        ensure
          tmp.close
        end
      end
    end
  end

  if description.include?(:repo)
    description[:repo].each do |repo|
      p = Hash[ repo.map { |k,v| [k.to_s, v] } ]
      machine.add_apt_repo(p)
    end
  end

  if description.include?(:package)
    machine.install_package(description[:package])
  end

  if description.include?(:gems)
    description[:gems].each do |gem|
      machine.sudo("gem install #{gem}")
    end
  end

  if description.include?(:github)
    description[:github].each do |repo|
      machine.deploy_from_github("github_project" => repo)
    end
  end

  if description.include?(:url)
    description[:url].each do |url|
      file_name = url.split("?").first.split("/").last
      puts "downloading to #{file_name} from #{url}"
      machine.download_file("url" => url, "file" => file_name)

      # TODO auto-extract?
    end
  end

  if description.include?(:service)
    description[:service].each do |service|
      machine.install_service(service: service)
    end
  end

  svc = plugin.state[:services].select { |x| x.name == service["name"] }.first
  raise "no service found named '#{service["name"]}'" unless svc
  svc.install_blocks.each_with_index do |install_block, idx|
    $logger.info "calling install block #{idx}"

    new_params = params.merge({
      service: service["name"],
      install_block: install_block
    })
    machine.run_install_block(new_params)
  end

  machine.processes!
  machine.detect_services!

  redis = plugin.state[:redis]
  redis.publish("installation_status", {
    "machine" => machine.name,
    "service" => service["name"]
  }.to_json())

  processed
end
