execute do |params|
  result = []
  
  @op.with_machine('self') do |machine|
    webapp = @op.vop_webapp_service
    machine.restart_service webapp
    result << webapp
    
    %w|launcher message_processor|.each do |svc|
      svc_name = "virtualop/#{svc}"
      if machine.list_installed_services.include? svc_name
        machine.restart_service svc_name
        result << svc_name
      end
    end
  end
  
  result
end
