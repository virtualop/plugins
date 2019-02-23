description "tries to return a meaningful string for the linux distribution running on this machine"

param! :machine

read_only

run do |machine, params|
  input = machine.ssh("cat /etc/issue")

  input.strip!
  first_line = input.split("\n").first

  result = 'unknown'
  if (matched = /SUSE\s+Linux\s+Enterprise\s+Server\s(\d+)\s+(SP\d+)?/.match(first_line))
    result = 'sles_' + matched.captures[0] + ' ' + matched.captures[1]
  elsif matched = /(\w+)[^\d]+([\d\.]+)/.match(first_line)
    result = matched.captures.first.downcase + '_' + matched.captures[1]
  end
  result
end
