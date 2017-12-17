module Vop

  class ServiceLoader

    def initialize(plugin)
      @plugin = plugin
      @op = plugin.op

      @services = []

      @plugin.inject_helpers(self)

      extend ServiceSyntax
    end

    def new_service(name)
      @service = Service.new(@plugin, name)
      @services << @service
      @service
    end

    def read_sources(named_sources)
      # reads a hash of <name> => <source string>
      named_sources.each do |name, source|

        new_service(name)

        begin
          self.instance_eval(source[:code], source[:file_name])
        rescue SyntaxError => detail
          raise Errors::ServiceLoadError.new("problem loading service #{name}", detail.backtrace.join("\n"))
        end
      end

      @services
    end

  end

  module Errors

    class ServiceLoadError < LoadError

    end

  end

end
