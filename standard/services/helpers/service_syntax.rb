module Vop

  module ServiceSyntax

    def resolve_options_string(options)
      if options.is_a? String
        options = {
          description: options
        }
      end
      options
    end

    def param(name, options = {})
      options = resolve_options_string(options)

      @service.params << CommandParam.new(name, options)
    end

    def param!(name, options = {})
      options = resolve_options_string(options)
      options.merge! mandatory: true
      param(name, options)
    end




    def process_regex(regex)
      @service.data[:process_regex] ||= []
      @service.data[:process_regex] << regex
    end

    def deploy(what = {}, &block)
      if block_given?
        @service.install_blocks << block
      end

      if what.include? :create
        files = @service.data[:install][:files] ||= {}
        files[:create] ||= []
        files[:create] << what[:create]
      end

      if what.include? :files
        raise "deploy (:files) needs a 'to' option" unless what.include?(:to)
        files = @service.data[:install][:files] ||= {}
        files[:copy] ||= []
        files[:copy] << {
          from: what[:files],
          to: what[:to]
        }
      end

      if what.include? :template
        raise "deploy (:template) needs a 'to' option" unless what.include?(:to)
        files = @service.data[:install][:files] ||= {}
        (files[:template] ||= []) << what
      end

      if what.include? :package
        @service.data[:install][:package] ||= []

        if what[:package].is_a?(Array)
            @service.data[:install][:package] += what[:package]
        else
          @service.data[:install][:package] << what[:package]
        end
      end

      if what.include? :gem
        @service.data[:install][:gems] ||= []

        gems = if what[:gem].is_a?(Array)
          what[:gem]
        else
          [ what[:gem] ]
        end
        @service.data[:install][:gems] += gems
      end

      if what.include? :repository
        @service.data[:install][:repo] ||= []

        if what[:repository].is_a?(Array)
            @service.data[:install][:repo] += what[:repository]
        else
          @service.data[:install][:repo] << what[:repository]
        end
      end

      if what.include? :url
        @service.data[:install][:url] ||= []
        @service.data[:install][:url] << what[:url]
      end

    end

    def known_binaries(list)

    end

    def version_command(command)

    end

    def port(port)

    end

    def icon(name)
      @service.data[:icon] = name
    end

    def vhost(vhost)

    end

  end

end
