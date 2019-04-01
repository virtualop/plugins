param! :machine

run do |machine|
  screenshots_dir = "/tmp/vop_screenshots"

  localhost = @op.machines["localhost"]
  localhost.mkdirs screenshots_dir

  path = machine.screenshot_vm

  $logger.debug "downloading screenshot from #{path}"
  local_file = "#{screenshots_dir}/#{machine.name}.ppm"
  machine.parent.scp_down(remote_path: path, local_path: local_file)

  png_file = local_file.split(".")[0..-2].join(".") + ".png"
  localhost.ssh("convert #{local_file} #{png_file}")

  png_file
end
