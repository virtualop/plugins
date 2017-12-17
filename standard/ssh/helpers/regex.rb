def regex_hash(line, regex, keys)
  result = nil

  matched = regex.match(line)
  if matched
    result = {}
    keys.each_with_index do |key, index|
      result[key] = matched.captures[index]
    end
  end

  result
end

# calls +command+ on +machine+ and uses +regex+ to parse into +keys+
# +options+ support an `:except` key holding a hash of regex => handler
# for special-casing by regex, e.g.
# {
#   except: {
#     /total\s+(\d+)/ => lambda { |matched|
#       puts "total is #{matched.captures.first}"
#     }
#   }
# }
# also supported is a `:post_process` block for transmogrifying parsed results
def ssh_regex(machine, command, regex, keys, options = {except: {}})
  result = []

  machine.ssh(command).lines.map do |line|
    if options.has_key? :except
      options[:except].each do |regex, block|
        if matched = regex.match(line)
          block.call(matched)
          next
        end
      end
    end

    parsed = regex_hash(line, regex, keys)
    if parsed
      if options.has_key? :post_process
        parsed = options[:post_process].call(parsed)
      end

      result << parsed
    end
  end

  result
end
