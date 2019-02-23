param! :machine

run do |machine|
  pools = machine.list_pools.map { |x| x["name"] }
  if pools.include? "images"
    "images"
  else
    "default"
  end
end
