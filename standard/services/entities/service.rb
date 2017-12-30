entity do |plugin|
  plugin.state[:services].map { |x| x.to_hash.merge("plugin_name" => x.plugin.name) }
end
