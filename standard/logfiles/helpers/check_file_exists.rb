def check_file_exists(machine, log_file)
  prefixes = %w|/var/log|
  needs_root = false
  prefixes.each do |prefix|
    if /#{prefix}/ =~ log_file
      needs_root = true
      break
    end
  end
  
  file_exists = needs_root ?
    machine.as_user('root') { |root|
      root.file_exists("file_name" => log_file)
    } :
    machine.file_exists("file_name" => log_file)
    
  file_exists
end