param! :machine
param "dir"

run do |machine, params|
  command = "df -hl"
  if params.has_key? "dir"
    command += " #{params["dir"]}"
  end

  machine.ssh(command).split("\n")[1..-1].map do |line|
    (path, size, used, available, percent, mount_point) = line.split
    {
      :path => path,
      :size => size,
      :used => used,
      :available => available,
      :percent => percent,
      :mount_point => mount_point
    }
  end
end

__END__

# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda8       481G  283G  174G  62% /data
