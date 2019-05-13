deploy template: "bash_prompt.sh.erb",
  to: "/etc/profile.d/bash_colors.sh"

deploy do |machine|
  machine.set_hostname machine.name.split(".").first
  # TODO set the domain as well?

  # to avoid package lock issues during apt update
  sleep 15

  machine.sudo "apt-get update"
  # thanks https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt#answer-147079
  machine.sudo "DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade -y"

  machine.install_package "apt-transport-https"

  machine.init_service_record_dir()
end
