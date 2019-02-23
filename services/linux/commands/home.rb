description "returns the currently logged in user's home directory (i.e. $HOME)"

param :machine, default_param: true

run do |machine|
  machine.ssh("echo $HOME").strip
end
