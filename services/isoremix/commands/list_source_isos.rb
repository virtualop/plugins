param! :machine

run do |machine|
  machine.list_files isoremix_dir("clean")
end

invalidate do |machine|
  machine.list_files! isoremix_dir("clean")
end
