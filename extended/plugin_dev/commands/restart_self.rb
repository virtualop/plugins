execute do |params|
  @op.with_machine('self') do |machine|
    machine.restart_service(@op.vop_webapp_service)
    
    %w|launcher message_processor|.each do |svc|
      if machine.list_installed_services.include? svc
        machine.restart_service svc
      end
    end
  end
end
