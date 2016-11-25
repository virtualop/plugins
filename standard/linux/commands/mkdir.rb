param! 'machine'
param! 'dir'

run do |machine, dir|
  machine.ssh("mkdir #{dir}")
end
