param! :machine
param! "template"
param! "to"
param "bind"

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
      if detail.message =~ /Permission denied/
        $logger.info "could not scp: #{detail.message}, gonna scp into /tmp and then sudo-mv"
        remote_tmp = Dir::Tmpname.make_tmpname(["/tmp/vop_template"], nil)
        begin
          machine.scp_up("local_path" => tmp.path, "remote_path" => remote_tmp)
          machine.sudo("mv #{remote_tmp} #{to}")
        ensure
          if machine.file_exists(remote_tmp)
            machine.ssh("rm #{remote_tmp}")
          end
        end
      end
    end

  ensure
    tmp.close
  end
end
