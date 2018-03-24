param! :machine

run do |machine|
  # TODO not working (user)
  key = "#{user}@#{host}:#{port}"
  $logger.debug("clearing ssh connection cache for #{key}")
  pool = plugin.state[:ssh_connections]
  pool.delete(key)
end
