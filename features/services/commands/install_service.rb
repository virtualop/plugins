require "tempfile"

param! :machine
param! :known_service, default_param: true
param "service_root", "path where the service should be installed"

allows_extra

run do |plugin, params, machine, known_service, service_root|
  processed = Hash.new { |h,k| h[k] = [] }

  detail = @op.describe_service(known_service: known_service["name"])
  unless service_root
    # if the service needs a service_root param, set a default
    unless detail["params"].nil?
      svc_root_param = detail["params"].select { |p| p["name"] == "service_root" }.first
      if svc_root_param && svc_root_param.has_key?("options") && svc_root_param["options"]["mandatory"]
        options = svc_root_param["options"]
        service_root = if options.has_key? "default"
          options["default"]
        else
          known_service.name
        end
        $logger.info "default service_root : #{service_root}"
        params["service_root"] = service_root
      end
    end
  end

  # prefix relative service_roots
  if service_root
    unless service_root.start_with? "/"
      params["service_root"] = "#{machine.home}/#{service_root}"
    end
  end

  @op.verify_mandatory_params(params)

  description = detail["install"]

  if description.include?("repo")
    description["repo"].each do |repo|
      p = Hash[ repo.map { |k,v| [k.to_s, v] } ]
      machine.add_apt_repo(p)
    end
  end

  if description.include?("package")
    machine.install_package(description["package"])
  end

  if description.include?("gems")
    description["gems"].each do |gem|
      machine.sudo("gem install #{gem}")
    end
  end

  if description.include?("github")
    description["github"].each do |repo|
      machine.deploy_from_github("github_project" => repo)
    end
  end

  if description.include?("url")
    description["url"].each do |url|
      file_name = url.split("?").first.split("/").last
      puts "downloading to #{file_name} from #{url}"
      machine.download_file("url" => url, "file" => file_name)

      # TODO auto-extract?
    end
  end

  if description.include?("service")
    description["service"].each do |other_service|
      machine.install_service(other_service)
    end
  end

  if description.include?("files")
    if description["files"].include?("create")
      creates = description["files"]["create"]
      creates.each do |what|
        if what.include? "in"
          machine.mkdirs(what["in"])
          (what["dirs"] || []).each do |dir|
            machine.mkdirs (File.join(what["in"], dir))
          end
          processed[:create] << what
        end
      end
    end

    if description["files"].include?("copy")
      copies = description["files"]["copy"]
      copies.each do |what|
        unless what.include?("from") && what.include?("to")
          raise "copy needs to include 'from' and 'to'"
        end

        local_path = File.join(known_service.plugin.plugin_dir(:files), what["from"])
        unless File.exists? local_path
          raise "file not found at #{local_path}"
        end
        # TODO this does not work if remote_path needs root permissions
        # (and current user is marvin)
        machine.scp_up("local_path" => local_path, "remote_path" => what["to"])
        processed[:copy] << what
      end
    end

    if description["files"].include?("template")
      templates = description["files"]["template"]
      templates.each do |what|
        unless what.include?("template") && what.include?("to")
          raise "template needs to include 'template' and 'to'"
        end

        template_path = File.join(known_service.plugin.plugin_dir(:templates), what["template"])
        unless File.exists? template_path
          raise "template not found at #{template_path}"
        end

        tmp = Tempfile.new("vop_service_install_template")
        begin
          # TODO could use more bindings?
          vars = {
            "service" => known_service,
            "machine" => machine
          }

          machine.write_template(
            template: template_path,
            to: what["to"],
            bind: OpenStruct.new(vars).instance_eval { binding }
          )
          $logger.info "template #{what["template"]} processed into #{what["to"]}"
        ensure
          tmp.close
        end
      end
    end
  end

  if description.include?("outgoing")
    # for now, configure outgoing connections only for VMs
    if machine.metadata["type"] == "vm"
      description["outgoing"].each do |protocol, port|
        $logger.info "configuring outbound connection #{protocol} #{port}"
        next unless %w|tcp udp|.include?(protocol.to_s)
        machine.parent.add_forward_include(
          source_machine: machine.name,
          service: known_service.name,
          content: "iptables -A FORWARD -s #{machine.internal_ip} -p #{protocol.to_s} --dport #{port}  -m state --state NEW -j ACCEPT"
        )
        machine.parent.generate_and_run_iptables
      end
    end
  end

  svc = plugin.state[:services].select { |x| x.name == known_service["name"] }.first
  raise "no service found named '#{known_service["name"]}'" unless svc
  svc.install_blocks.each_with_index do |install_block, idx|
    $logger.info "calling install block #{idx}"

    new_params = params.merge({
      known_service: known_service["name"],
      install_block: install_block
    })
    machine.run_install_block(new_params)
  end

  # record service installation
  record_dir = plugin.config["installed_services_dir"]
  machine.mkdirs(record_dir)
  if machine.file_exists(record_dir)
    record_file = "#{record_dir}/#{known_service["name"]}"
    record_data = params.merge({
      name: known_service["name"]
    })
    machine.write_file(
      file_name: record_file,
      content: record_data.to_json
  )
  end

  # invalidate
  machine.processes!
  machine.detect_services!

  

  # redis notification
  redis = plugin.state[:redis]
  redis.publish("installation_status", {
    "machine" => machine.name,
    "service" => known_service["name"]
  }.to_json())

  processed
end
