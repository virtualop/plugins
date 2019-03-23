param! :machine
param! "template"
param! "to"
param "bind", default: nil

run do |machine, template, to, params, bind|
  tmp = Tempfile.new("vop_write_template")
  begin
    renderer = ERB.new(IO.read(template))
    tmp << renderer.result(bind)
    tmp.flush
    $logger.debug "processed template written into #{tmp.path}"
    begin
      machine.scp_up("local_path" => tmp.path, "remote_path" => to)
    rescue => detail
      # TODO move this maneuver into something like write_file ?
      if detail.message =~ /Permission denied/
        $logger.debug "could not scp as mortal user into #{to}, gonna scp into /tmp and then sudo-mv"
        $logger.debug detail.message
        remote_tmp = "/tmp/vop_template_scp_sudo_mv_#{to.gsub("/", "_")}_#{Time.now.utc.to_i}"
        begin
          machine.scp_up("local_path" => tmp.path, "remote_path" => remote_tmp)
          machine.sudo("mv #{remote_tmp} #{to}")
        ensure
          if machine.file_exists(remote_tmp)
            machine.ssh("rm #{remote_tmp}")
          end
        end
      else
        raise detail
      end
    end

  ensure
    tmp.close
  end
end
