param! :machine

param! "command", default_param: true

param "show_output", default: false
param "request_pty", default: false

param "on_data", default: nil
param "on_stderr", default: nil
param "dont_loop", default: false, description: "if set to true, the command will return after spawning the process without waiting for it to terminate."

dont_log

run do |machine, params, show_output|
  connection = machine.get_ssh_connection

  $logger.debug "request_pty ? #{params["request_pty"]}"

  stdout = ""
  stderr = ""
  combined = ""
  result_code = nil
  connection.open_channel do |channel|
    if params.has_key?('request_pty') && params['request_pty'].to_s == "true"
      $logger.debug "requesting pty"
      channel.request_pty do |ch, success|
        unless success
          raise Exception.new("could not obtain pty!")
        end
      end
    end

    channel.on_request('exit-status') do |c, data|
      result_code = data.read_long
      $logger.debug "read exit code : #{result_code}"
    end

    params["on_data"] ||= lambda do |c, data|
      stdout += data
      combined += data

      puts data if show_output
      $logger.debug "got data on STDOUT #{data}"
    end
    channel.on_data do |c, data|
      params["on_data"].call(c, data)
    end

    params["on_stderr"] ||= lambda do |c, data|
      stderr += data
      combined += data

      puts data if show_output # TODO to stderr
      $logger.debug "got data on STDERR #{data}"
    end
    channel.on_extended_data do |c, type, data|
      params["on_stderr"].call(c, data)
    end

    #channel.on_close { $logger.debug "done" }

    command = params["command"]

    channel.exec(command) do |ch, success|
      if success
        $logger.debug "executed command successfully."
      else
        $logger.warn "could not execute command #{command}"
        raise RuntimeError.new("could not execute #{command}")
      end
    end
  end

  if params.has_key?('dont_loop') and params['dont_loop']
    $logger.debug "not waiting for process to finish"
    {
      "combined" => combined,
      "stdout" => stdout,
      "stderr" => stderr,
      "connection" => connection
    }
  else
    connection.loop

    lines = params["command"].lines
    first_line = lines.first
    short_command = first_line.strip[0..49]
    if lines.size > 1 || first_line.size > 50
      short_command += "[...]"
    end
    $logger.info "ssh [#{params["machine"]}] #{first_line}, result : #{result_code}"
    $logger.debug "full command : #{params["command"].lines.join("\n")}"

    {
      "combined" => combined,
      "stdout" => stdout,
      "stderr" => stderr,
      "result_code" => result_code
    }
  end
end
