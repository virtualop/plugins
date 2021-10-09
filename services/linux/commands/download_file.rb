param! :machine
param! "url"
param! "file"

run do |machine, url, file|
  # install curl if missing
  has_curl = machine.ssh_call("which curl")["result_code"] == 0
  unless has_curl
    machine.install_package("curl")
  end

  # assemble curl command
  command = "curl --silent --location"
  command += " --create-dirs -o #{file}"
  command += " '#{url}'"
  $logger.debug "command: #{command}"

  # invoke curl to download
  machine.ssh(command) unless machine.file_exists(file)
end
