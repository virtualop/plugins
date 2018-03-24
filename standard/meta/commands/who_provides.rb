# TODO would be nice if we had a :command entity
param! 'command_name', :lookup => lambda { |params| @op.commands.keys }

run do |command_name|
  @op.commands[command_name].plugin.name
end
