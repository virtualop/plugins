param! :machine

param "version", default: "18.04"

run do |machine, version|
  dir = isoremix_dir("clean")

  major = version.split(".").first.to_i

  if major >= 18
    upstream_url = "http://cdimage.ubuntu.com/releases/#{version}/release/"
  else
    upstream_url = "http://releases.ubuntu.com/#{version}"
  end

  input = machine.curl "#{upstream_url}/"
  links = input.scan /<a href="(ubuntu-(#{version}[\.\d]+)-(.+?)-(.+?)\.([^>]+))">/

  links.map do |link|
    {
      url: "#{upstream_url}/#{link[0]}",
      version: link[1],
      type: link[2],
      arch: link[3],
      extension: link[4]
    }
  end
end
