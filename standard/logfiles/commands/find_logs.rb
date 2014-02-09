description "returns logfiles on a machine"

param :machine

add_columns [ :service, :path, :source, :format, :parser ]

with_contributions do |contrib, params|
  result = []
  
  @op.with_machine(params['machine']) do |machine|
    logs = (contrib ? contrib : [])
    
    machine.list_services.each do |service|
      next unless service.has_key? 'log_files' 
      service["log_files"].each do |log|
        # prefix relative paths
        unless /^[\/\$]/ =~ log['path']
          prefix = service.has_key?('service_root') ?
            service["service_root"] : machine.home
          log['path'] = prefix + '/' + log['path']
        end
        
        log['service'] = service['full_name']
        log['source'] = service['name']
        logs << log
      end
    end
    
    logs.each do |log|
      next unless log
      
      log_file = log['path']
    
      $logger.info "checking for #{log_file}..."
        
      file_exists = (machine.machine_detail["os"] == 'windows') ?
        machine.win_file_exists("file_name" => log_file) :
        check_file_exists(machine, log_file)
      
      if file_exists
        log['format'] ||= 'freestyle'
        result << log
      end
    end
  end
  
  result
end