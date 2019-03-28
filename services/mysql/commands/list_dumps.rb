param! :machine

read_only

run do |machine|
  machine.list_files(dump_dir(machine))
end

invalidate do |machine|
  machine.list_files!(dump_dir(machine))
end
