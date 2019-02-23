param! :machine
param! "version"

run do |machine, version|
  dir = isoremix_dir("clean")

  isos = machine.find_ubuntu_isos(version: version).select do |file|
    file[:extension] == "iso" &&
    file[:arch] == "amd64" &&
    file[:type] == "server"
  end

  iso = isos.first
  raise "no ISO found" if iso.nil?

  url = iso[:url]
  $logger.info "found URL : #{url}"

  file_name = url.split("/").last
  machine.download_file(
    url: url,
    file: "#{dir}/#{file_name}"
  )
end
