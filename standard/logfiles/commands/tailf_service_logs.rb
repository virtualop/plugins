param :machine
param :service

on_machine do |machine, params|
  service_logs = machine.find_logs.select { |x| x["service"] == params["service"] }.pick('path')
  machine.tailf("file_name" => service_logs) if service_logs
end