param "no_cache", default: false

run do |no_cache|
  $vop.machines.each do |machine|
    SshTestWorker.perform_async(machine.name, no_cache)
  end
  42
end
