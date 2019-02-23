param! :machine
param! "url", default_param: true

run do |machine, url|
  has_curl = machine.ssh("which curl")

  $logger.debug "has_curl: #{has_curl}"
  raise "no curl" unless has_curl

  command = "curl --location"
  command += " '#{url}'"

  $logger.debug "command: #{command}"
  machine.ssh(command)
end
