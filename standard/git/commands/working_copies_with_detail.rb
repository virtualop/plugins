param! :machine

run do |machine|
  machine.list_working_copies.map do |working_copy|
    path = working_copy[:path]

    detail = {
      current_revision: machine.current_revision("working_copy" => path),
      changes: machine.git_status("working_copy" => path)
    }
    working_copy.merge(detail)
  end
end
