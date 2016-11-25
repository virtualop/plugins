param! 'machine'
param! 'dir'

run do |machine, dir|  
  machine.list_files(dir: dir)
end
