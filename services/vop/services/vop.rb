deploy repository: {
  alias: "vop",
  url: "http://repo.virtualop.org/ubuntu/",
  dist: "bionic main",
  key: "http://repo.virtualop.org/ubuntu/dists/bionic/Release.key",
  arch: "amd64",
}

deploy package: "virtualop"

local_files path: "/etc/vop", alias: "config"

binary_name "vop"
icon "vop_16px.png"

deploy do |machine|
  machine.vop_init
end
