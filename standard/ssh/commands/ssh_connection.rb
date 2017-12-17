param! :machine

run do |plugin, machine|
  ssh_opts = @op.ssh_options("machine" => machine.name)
  $logger.debug "ssh options for #{machine.name} : #{ssh_opts.pretty_inspect}"
  if ssh_opts.nil? || ssh_opts.empty?
    raise "no SSH options for machine #{machine.name}"
  end

  host = ssh_opts["host_or_ip"]
  user = ssh_opts["user"] || ENV["USER"]
  port = ssh_opts["port"] || 22
  options = ssh_opts.has_key?("options") ? ssh_opts["options"] : {}

  options[:port] = port

  if ssh_opts.has_key? "password"
    options[:password] = ssh_opts["password"]
  end

  key = "#{user}@#{host}:#{port}"
  $logger.debug("ssh connection to #{key}")

  pool = plugin.state[:ssh_connections]
  connection = pool[key]
  if connection.nil?
    $logger.debug "new SSH connection as #{user} to #{host} (#{options.pretty_inspect})"

    if ssh_opts["jump_host"]
      jump_host_name = ssh_opts["jump_host"]
      jump_host = @op.ssh_options(jump_host_name)
      $logger.debug "using jump host #{jump_host_name}"
      proxy = Net::SSH::Proxy::Jump.new("#{jump_host["user"]}@#{jump_host["host_or_ip"]}")
      options[:proxy] = proxy
    end

    connection = Net::SSH.start(host, user, options)
    pool[key] = connection unless ssh_opts["jump_host"]
  end

  connection
end
