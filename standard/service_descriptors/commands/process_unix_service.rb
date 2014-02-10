contributes_to :post_process_service_installation

param :machine
param :service, "", :default_param => true

accept_extra_params

on_machine do |machine, params|
  service = @op.service_details(params)
  
  if service.has_key?('unix_service')
    unix_service = service['unix_service']
    if unix_service.is_a? Hash
      unix_service_name = machine.unix_service_name("unix_service" => service["unix_service"])
      machine.mark_unix_service_for_autostart('name' => unix_service_name)
    elsif unix_service.is_a? String
      machine.mark_unix_service_for_autostart('name' => unix_service)
    else
      $logger.error("process_unix_service found a unix_service in #{service['full_name']}, but does not know how to process this type of data.")
    end
  end
end