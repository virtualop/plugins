param! "graph"

run do |graph|
  result = {}
  graph.each do |selector, g|
    result[selector] = g.map do |entry|
      (timestamp, value) = entry
      ts = DateTime.parse(timestamp.to_s).strftime("%s")
      [ts, value]
    end
  end
  result
end
