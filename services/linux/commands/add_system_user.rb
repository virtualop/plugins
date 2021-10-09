description "invokes 'useradd' to create a new user account on this machine"

param :machine
param! 'name', 'unique name for the new user account', default_param: true

param 'with_group', 'if set to true, will also create a group with the same name as the user', default: false
param 'system_account', 'create a system account (has no homedir by default)', default: true
param 'with_homedir', 'if set to false, will create a user account, but not the home dir', default: false
param 'homedir_path', 'explicit path for a homedir that should be used'
param 'shell', 'path to a program that should be used as login shell'

run do |machine, name, with_homedir, with_group, params|
  user_exists = machine.list_system_users.map { |x| x['name'] }.include? name

  unless user_exists
    group = params['with_group'] ? '-G' : ''
    if params['homedir_path']
      homedir = "--home #{params['homedir_path']}"
      # implicitly enable with_homedir when homedir_path is set
      params['with_homedir'] = true
    end
    create_home = params['with_homedir'] ? '-m' : '-M'
    shell = "--shell #{params['shell']}" if params['shell']

    options = [ create_home, group, homedir, shell ].compact.join(" ")
    machine.sudo "useradd #{options} #{name}"

    machine.read_file! "/etc/passwd"
  end
end
