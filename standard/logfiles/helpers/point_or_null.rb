def point_or_null(line, ts)
  point = line.select { |x| x[0] == ts }.first
  if point
    point
  else
    [ ts, 0 ]
  end
end