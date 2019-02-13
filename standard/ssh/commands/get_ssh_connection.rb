require "timeout"

param! :machine
param "force", default: false
param "timeout", description: "in seconds", default: 10

dont_log

run do |machine, force|
  seconds = seconds.to_i
  connection = nil
  begin
    Timeout::timeout(seconds) do
      tried_with_force = false
      done = false
      until tried_with_force || done do
        connection = machine.ssh_connection(force: force)
        tried_with_force = true if force
        begin
          connection.exec! "hostname"
          done = true
        rescue => e
          if force
            state = force ? "fresh " : ""
            raise "problem while testing #{state}ssh connection to #{machine.name} : #{e.message}"
          else
            $logger.debug "SSH check failed (#{e.message}), requesting fresh connection to #{machine.name}"
            force = true
          end
        end
      end
    end
  rescue => detail
    raise "timed out while connecting to #{machine.name} : #{detail.message}"
  end

  connection
end
