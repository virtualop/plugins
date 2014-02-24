param :machine

param 'version', 'the github tree (release/tag/branch) to export', :default_value => 'stable'

param 'extra_folder', 'extra folder to use with +rpm_base+ to build the +target_dir+', :default_value => ''

param 'rpm_base', 'directory inside which rpm repos can be found', :default_value => '/var/www/html/packages'

on_machine do |machine, params|
  
  target_dir = params['rpm_base']
  target_dir += '/' + params['extra_folder'] if params['extra_folder'] != ''
  target_dir += '/rpm'
  
  machine.github_to_rpm(
    'github_repo' => 'virtualop/virtualop', 
    'source_repo' => [ 'virtualop/plugins', 'virtualop/services' ],
    'rpm_name' => 'virtualop',      
    'target_dir' => target_dir,
    'tree' => params['version'],
    'extra_params' => { 
      'version' => params['version'],
      'suffix' => '-with-ruby',
      'extra_requires' => 'rvm-ruby'
    }
  )
    
  machine.github_to_rpm(
    'github_repo' => 'virtualop/virtualop_webapp',
    'rpm_name' => 'virtualop-webapp',
    'target_dir' => target_dir,
    'tree' => params['version'],
    'extra_params' => { 
      'version' => params['version']
    }
  )
end
