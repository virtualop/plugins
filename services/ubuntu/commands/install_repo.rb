param! :machine
param! "repo_line", default_param: true

run do |machine, repo_line|
  machine.sudo("apt-add-repository -y #{repo_line}")
  machine.sudo("apt-get update")
end
