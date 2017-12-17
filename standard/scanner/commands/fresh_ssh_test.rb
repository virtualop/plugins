param! :machine

run do |machine|
  $vop.invalidate_cache("command" => "test_ssh", "raw_params" => { "machine" => machine.name })
  machine.test_ssh
end
