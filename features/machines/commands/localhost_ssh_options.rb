param! :machine

# TODO : move to local config && example in the documentation
contribute to: "ssh_options" do |machine|
  if (! machine.nil?) && machine.name && machine.name == "localhost"
    {
      "port" => 2233
    }
  end
end
