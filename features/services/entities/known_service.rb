show columns: []

key "name"

entity do |plugin|
  plugin.state[:services].map do |x|
    h = x.to_hash.merge(
      "name" => x.name,
      "plugin_name" => x.plugin.name,
      "params" => x.params
    )

    if x.data[:icon]
      h["icon"] = File.join(x.plugin.plugin_dir(:files), x.data[:icon])
    end

    h["installable"] = x.data.has_key? :install
    h
  end
end
