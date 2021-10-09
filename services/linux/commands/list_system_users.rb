description "reads a list of configured users from the system's /etc/passwd"

param! :machine

show columns: [ :name, :uid, :gid, :home_dir ]

run do |machine|
  machine.read_file("/etc/passwd").split("\n").map do |line|
    name, x, uid, gid, description, home_dir, login_shell = line.split(':')
    {
      "name" => name,
      "uid" => uid,
      "gid" => gid,
      "description" => description,
      "home_dir" => home_dir,
      "login_shell" => login_shell
    }
  end
end
