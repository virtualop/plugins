param! :machine
param! "working_copy"
param! "file_name", description: "the file that should be added", multi: true

run do |machine, working_copy, file_name|
  git_status = machine.git_status(working_copy)

  # discard a change on an existing file or remove a file that has not been added yet?
  file_name.each do |file|
    file_status = git_status.select do |row|
      row["path"] == file
    end.first
    if file_status.nil?
      raise "[sanity check] file #{file} not found in status for working copy #{working_copy}. found:\n#{git_status.pretty_inspect}"
    end

    if file_status["raw"] == "??"
      machine.ssh "cd #{working_copy} && rm #{file}"
    else
      machine.ssh "cd #{working_copy} && git checkout -- #{file}"
    end
  end


  machine.git_status! working_copy: working_copy
end
