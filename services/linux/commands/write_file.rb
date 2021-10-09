param! :machine
param! "file_name"
param! "content"
param "sudo", default: false

run do |machine, file_name, content, sudo|
  content.gsub! /[']/, "'\"'\"'"

  def try_write(machine, file_name, content, force_sudo)
    $logger.debug "try write?"
    write_cmd = if force_sudo
      "| sudo tee #{file_name}"
    else
      "> #{file_name}"
    end
    $logger.debug "write_cmd : #{write_cmd}"
    machine.ssh "echo '#{content}' #{write_cmd}"
  end

  begin
    $logger.debug("about to write")
    try_write(machine, file_name, content, sudo)
    $logger.debug("wrote")
  rescue => detail
    # sudo make me a sandwich
    if detail.message =~ /Permission denied/
      $logger.debug "could not write as mortal user, trying sudo"
      $logger.debug detail.message
      try_write(machine, file_name, content, true)
    else
      raise
    end
  ensure
    machine.read_file! file_name
  end
end
