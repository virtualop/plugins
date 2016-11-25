param! 'machine'
param! 'dir'

show columns: %i|name owner group permissions size timestamp|

run do |machine, dir|
  ssh_regex(machine, "ls -l --full-time #{dir}",
    # drwxrwxr-x   3  philipp philipp 4096    2016-01-16 04:16:24.621111156 +0100 lib
    /(\S+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+)\s+([\d-]+)\s+([\d:]+)\.\d+\s+(\+\d+)\s+(.+)$/,
    %i|permissions links owner group size date time time_zone name|,
    {
      :post_process => lambda { |parsed|
        date, time, zone = parsed.delete(:date), parsed.delete(:time), parsed.delete(:time_zone)
        parsed[:timestamp] = "#{date} #{time} #{zone}"
        parsed
      }
    }
  )
end
