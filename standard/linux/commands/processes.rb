param! "machine"

show columns: %i|pid command_short|

run do |params, machine|
  input = machine.ssh("ps aux")

  input.split("\n")[1..-1].map do |line|
    parts = line.split()
    (user, pid, cpu, mem, vsz, rss, tty, stat, start, time) = parts[0..9]
    command = parts[10..parts.length-1].join(" ")
    {
      pid: pid,
      command: command,
      command_short: command[0..119],
      user: user
    }
  end
end

__END__

# USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root         1  0.0  0.0 185312  5832 ?        Ss   Feb03   0:01 /sbin/init splash
# root         2  0.0  0.0      0     0 ?        S    Feb03   0:00 [kthreadd]
# root         3  0.0  0.0      0     0 ?        S    Feb03   0:00 [ksoftirqd/0]
# root         5  0.0  0.0      0     0 ?        S<   Feb03   0:00 [kworker/0:0H]
# [..]
# philipp  15036  0.0  0.0  28424  4264 pts/5    Ss   04:47   0:00 /bin/bash
# philipp  15144  0.0  0.0  28416  4216 pts/8    Ss+  04:49   0:00 /bin/bash
# root     15168  0.0  0.0      0     0 ?        S    04:51   0:00 [kworker/u8:0]
# philipp  15193  0.0  0.0  25668  2932 pts/5    R+   04:53   0:00 ps aux
# philipp  15194  0.0  0.0  14452  2232 pts/5    S+   04:53   0:00 tail -n5
