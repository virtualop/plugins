entity do |plugin|
  plugin.state[:services].map do |x|
    x.to_hash.merge(
      "plugin_name" => x.plugin.name,
      "params" => x.params
    )
  end
end
