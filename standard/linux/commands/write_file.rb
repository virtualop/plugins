require "tempfile"

param! :machine
param! "file"
param! "content"

run do |machine, file, content|
  bytes_written = 0
  name_fragment = "vop_#{$$}_"
  tmp = Tempfile.new(name_fragment)
  begin
    tmp.write content
    bytes_written = tmp.size
    tmp.flush()
    tmp.close()

    $logger.debug "scp from #{tmp.path} to #{file}"
    machine.scp(
      local_path: tmp.path,
      remote_path: file
    )
  ensure
    tmp.delete
  end
  bytes_written
end
