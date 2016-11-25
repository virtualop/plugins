param! 'machine'

run do |machine|
  @op.list_project_folders.each do |project_folder|
    machine.list_files(dir: project_folder).map { |x| x[:name] }
    # TODO search for .git dirs?
  end
end
