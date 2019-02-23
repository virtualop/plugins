require_relative "../helpers/service_loader"
require_relative "../helpers/service"
require_relative "../helpers/service_syntax"

description "loads services defined in plugins"

run do |plugin|
  @op.plugins.each do |one_plugin|
    one_plugin.load_code_from_dir :services
    if one_plugin.sources[:services].keys.size > 0
      $logger.debug "  found services in #{one_plugin.name} : #{one_plugin.sources[:services].keys}"
      loader = ServiceLoader.new(one_plugin.clone)
      loaded = loader.read_sources(one_plugin.sources[:services])
      plugin.state[:services] += loaded
    end
  end
end
