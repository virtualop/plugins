param! :known_service
param :machine

show display_type: :data

run do |plugin, known_service, machine|
  result = known_service.data

  if machine
    installation_params = machine.installed_services[known_service.name].data
    result.merge!({
      "installed" => installation_params
    })
  end

  result
end
