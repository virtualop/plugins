param! :machine
param! "ip"
param! "content"

run do |machine, ip, content|
  hosts = machine.read_file("/etc/hosts").split("\n")
  ip.gsub!(".", "\.")
  regex = /#{ip}/

  unless hosts.grep(regex)
    raise "IP #{ip} not found in hosts file:\n#{hosts}"
  end

  new_hosts = hosts.map do |host|
    if host =~ regex
      "#{ip} #{content}"
    else
      host
    end
  end.join("\n")

  machine.write_file(
    file_name: "/etc/hosts",
    content: new_hosts,
    sudo: true
  )
end
