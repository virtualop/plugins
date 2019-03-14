param! :machine
param! :log
param! "data"

dont_log

run do |machine, log, data|
  parser = log["parser"]
  if parser.nil?
    raise "no parser definition found for log file #{path} (service probably : #{log["source"]})"
  end

  result = nil
  if @op.respond_to?(parser)
    result = @op.send(parser.to_sym, data)
  else
    raise "parser command defined for log #{path} in #{log["source"]} does not seem to be registered in this vop instance."
  end
  result
end
