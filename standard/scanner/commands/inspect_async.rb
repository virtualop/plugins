param! :machine

run do |machine|
  request = ::Vop::Request.new(@op, "inspect_machine", {"machine" => machine.name})
  @op.execute_async(request)
end
