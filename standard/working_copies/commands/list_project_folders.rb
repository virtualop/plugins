#description "project folders are locations in which working copies are searched"

run do
  [
    File.join(ENV["HOME"], "projects"),
    File.join(ENV["HOME"], "Sites"),
  ]
end
