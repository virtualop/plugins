param! :machine
param "force", default: false
param "dont_cache", default: false

dont_log

run do |context, plugin, machine, force, dont_cache|
  ssh_opts = @op.ssh_options("machine" => machine.name)
  $logger.debug "ssh options for #{machine.name} : #{ssh_opts.pretty_inspect}"
  if ssh_opts.nil?
    raise "no SSH options for machine #{machine.name}"
  end

  host = ssh_opts["host_or_ip"] || machine.name
  user = ssh_opts["user"] || context["system_user"] || ENV["USER"]
  key = "#{user}@#{host}"

  options = ssh_opts.has_key?("options") ? ssh_opts["options"] : {}
  if ssh_opts["port"]
    port = ssh_opts["port"]
    options[:port] = port
    key += ":#{port}"
  end

  if ssh_opts.has_key? "password"
    options[:password] = ssh_opts["password"]
  end

  $logger.debug("ssh connection to #{key}")

  pool = plugin.state[:ssh_connections]
  connection = nil
  connection = pool[key] unless force

  if connection.nil?
    if ssh_opts["jump_host"]
      jump_host_name = ssh_opts["jump_host"]
      jump_host = @op.ssh_options(jump_host_name)
      $logger.debug "using jump host #{jump_host_name}"
      jump_pool = plugin.state[:jump_connections]
      jump_target = "#{jump_host["user"]}@#{jump_host["host_or_ip"]}"
      cached_jump_host = jump_pool[jump_target] unless force
      proxy = if cached_jump_host
        cached_jump_host
      else
        $logger.debug "new connection to jump host #{jump_target}"
        new_proxy = Net::SSH::Proxy::Jump.new(jump_target)
        jump_pool[jump_target] = new_proxy unless dont_cache
        new_proxy
      end
      options[:proxy] = proxy
    end

    $logger.debug "new SSH connection as #{user} to #{host} (#{options.pretty_inspect})"
    connection = Net::SSH.start(host, user, options)
    pool[key] = connection unless dont_cache #unless ssh_opts["jump_host"]
  end

  connection
end
