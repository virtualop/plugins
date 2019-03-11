param! :machine
param! "dir", default_param: true

param "extra_filter", description: "value to filter against the 'extra' field"

read_only

show columns: %w|name owner group permissions size timestamp|

run do |machine, dir, extra_filter|
  ssh_regex(machine, "ls -l --full-time #{dir}",
    # drwxrwxr-x   3  philipp philipp 4096    2016-01-16 04:16:24.621111156 +0100 lib
    /(\S+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+)\s+([\d-]+)\s+([\d:]+)\.\d+\s+(\+\d+)\s+(.+)$/,
    %w|attributes links owner group size date time time_zone name|,
    {
      :post_process => lambda { |parsed|
        # parse attributes
        parsed["extra"] = parsed["attributes"][0]
        parsed["permissions"] = parsed["attributes"][1..-1]

        # reformat the timestamp
        date, time, zone = parsed.delete("date"), parsed.delete("time"), parsed.delete("time_zone")
        parsed["timestamp"] = "#{date} #{time} #{zone}"

        if extra_filter
          if parsed["extra"] == extra_filter
            parsed
          else
            nil
          end
        else
          parsed
        end
      }
    }
  )
end
