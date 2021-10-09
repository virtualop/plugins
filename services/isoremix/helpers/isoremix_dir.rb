def isoremix_dir(sub)
  result = File.join(@plugin.config["isoremix_root"], sub)
  result += "/" unless result.end_with?("/")
  result
end
