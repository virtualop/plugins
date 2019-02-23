param! :machine

contribute to: "ssh_options" do |machine|
  if (! machine.nil?) && machine.name && machine.name == "localhost"
    {
      "user" => ENV["USER"]
    }
  end
end
