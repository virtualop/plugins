param! 'chef_dir' # TODO from_config?

contribute to: "machine" do |chef_dir|
  output = @op.system_call("cd #{chef_dir} && knife node list")
  output.lines.map do |x|
    { :name => x.strip }
  end
end
