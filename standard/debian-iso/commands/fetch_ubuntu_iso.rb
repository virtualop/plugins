param! 'machine'
param! 'dir'

param! 'version', :default => '16.04'

run do |machine, dir, version|
  # sigh
  urls = {
    '16.04' => 'http://releases.ubuntu.com/16.04/ubuntu-16.04-server-amd64.iso',
    '14.04' => 'http://releases.ubuntu.com/14.04/ubuntu-14.04.4-server-amd64.iso'
  }
  url = urls[version]
  unless url
    url = "http://releases.ubuntu.com/%s/ubuntu-%s-server-amd64.iso" % [version, version]
  end

  file_name = url.split('/').last
  machine.download_file(
    url: url,
    file: "#{dir}/#{file_name}"
  )
end
