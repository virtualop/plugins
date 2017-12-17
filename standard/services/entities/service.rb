entity do |plugin|
  plugin.state[:services].map { |x| x.to_hash }
end
