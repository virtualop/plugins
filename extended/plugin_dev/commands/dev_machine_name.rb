param 'suffix', 'string to append to "dev_<user>_" to build the new machine name'
param :current_user

param 'full'

mark_as_read_only

execute do |params|
  suffix = params['suffix'] ? "_#{params['suffix']}" : ''
  
  user = params['current_user']
  raise 'no user?' unless user
  
  s = "dev_#{user}" + suffix
  
  if params['full'] && params['full'].to_s == 'true'
    # TODO that does not scale
    potential_hostname = @op.plugin_by_name('installation').config_string('installation_target').first
    s += ".#{potential_hostname}"
  end
  
  s
end