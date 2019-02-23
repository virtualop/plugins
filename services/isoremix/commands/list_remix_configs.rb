param! :machine

run do |machine|
  machine.list_files isoremix_dir("config")
end

invalidate do |machine|
  machine.list_files! isoremix_dir("config")
end
