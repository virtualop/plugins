description "hook that is called when a spare has been converted"

param! :machine
param "converted"

run do |machine, converted|
  $logger.info "post_convert_spare #{machine.name} (#{converted})"

  request = ::Vop::Request.new(@op, "prepare_spares", {"machine" => machine.name})
  @op.execute_async(request)
end
