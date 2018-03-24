param! :machine
param! "url"
param! "file"

run do |machine, url, file|
  has_curl = machine.ssh("which curl")

  $logger.debug "has_curl: #{has_curl}"
  raise "no curl" unless has_curl

  command = "curl --silent --location"
  command += " --create-dirs -o #{file}"
  command += " '#{url}'"

  $logger.debug "command: #{command}"
  machine.ssh(command)
end
