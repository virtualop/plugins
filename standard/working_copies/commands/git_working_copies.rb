param! 'machine'

contribute :to => 'working_copy' do |machine|
  result = []
  @op.list_project_folders.each do |project_folder|
    machine.find("path" => project_folder, "type" => 'd', "name" => '.git').each { |folder|
      result << { name: folder }
    }
  end
  result
end
