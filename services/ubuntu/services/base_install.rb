deploy do |machine|
  machine.set_hostname machine.name.split(".").first
  # TODO set the domain as well?

  machine.sudo "apt-get update"
  # thanks https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt#answer-147079
  machine.sudo "DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade -y"

  machine.install_package "apt-transport-https"
end
