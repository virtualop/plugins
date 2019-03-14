param! :machine
param! "file"

param "count", default: 25

param "sudo", default: false, description: "should sudo be used to call tail?"

run do |params|
  request = ::Vop::Request.new(@op, "keep_tailing", params)
  @op.execute_async(request)
end
