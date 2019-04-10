description "creates a tarball from specified files"

param :machine
param! "tar_name", "the path to the tarball that should be created"
param! "files", "the file (or file pattern) that should  be tarred"
param! "working_dir", "the directory in which the tarball should be created"

run do |machine, tar_name, files, working_dir|
  machine.ssh "cd #{working_dir} && tar -czf #{tar_name} #{files} && cd -"
  $logger.info "created tarball at #{tar_name} with pattern #{files} in dir #{working_dir}"
end
