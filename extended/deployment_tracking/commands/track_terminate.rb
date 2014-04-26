contributes_to :notify_terminate_stop_ok

param :current_user

accept_extra_params

execute do |params|
  machine_name = params["extra_params"]["result"]
  m = Machine.find_by_name machine_name
  m.delete()
end