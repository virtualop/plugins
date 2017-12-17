require "erb"
require "tempfile"

param! :machine
param! :service



run do |plugin, machine, service|
  processed = Hash.new { |h,k| h[k] = [] }

  description = service.data[:install]
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
          renderer = ERB.new(IO.read(template_path))
          # TODO could use some bindings
          tmp << renderer.result
          tmp.flush
          $logger.info "processed template written into #{tmp.path}"
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
      params = Hash[ repo.map { |k,v| [k.to_s, v] } ]
      machine.add_apt_repo(params)
    end
  end

  if description.include?(:package)
    machine.install_package(description[:package])
    # TODO test and remove
    # description[:package].each do |package|
    #   machine.sudo("command" => "apt-get install -y #{package}")
    # end
  end

  if description.include?(:url)
    description[:url].each do |url|
      file_name = url.split("?").first.split("/").last
      puts "downloading to #{file_name} from #{url}"
      machine.download_file("url" => url, "file" => file_name)

      # TODO auto-extract?
    end
  end

  svc = plugin.state[:services].select { |x| x.name == service["name"] }.first
  raise "no service found named '#{service["name"]}'" unless svc
  svc.install_blocks.each_with_index do |install_block, idx|
    $logger.info "calling install block #{idx}"
    install_block.call(machine)
  end

  machine.processes!
  machine.detect_services!

  processed
end
