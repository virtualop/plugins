show display_type: :raw

run do
  @op.plugins.map do |plugin|
    { "name" => plugin.name,
      "config" => @op.show("plugin_name" => plugin.name)
    }
  end
end
