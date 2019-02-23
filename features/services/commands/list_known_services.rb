read_only

run do |plugin|
  plugin.state[:services].map do |service|
    h = {
      "name" => service.name      
    }
    if service.data[:icon]
      h["icon"] = File.join(service.plugin.plugin_dir(:files), service.data[:icon])
    end
    h["installable"] = service.data.has_key? :install
    h
  end
end
