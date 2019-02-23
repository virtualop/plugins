param! :machine

run do |machine|
  machine.list_files isoremix_dir("rebuilt")
end

invalidate do |machine|
  machine.list_files! isoremix_dir("rebuilt")
end
