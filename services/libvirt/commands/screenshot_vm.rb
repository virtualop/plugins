param! :machine

param "file"

run do |machine, file|
  short_name = machine.name.split(".").first

  file ||= "#{short_name}.ppm"

  machine.parent.sudo "virsh screenshot #{short_name} --file #{file}"
end
