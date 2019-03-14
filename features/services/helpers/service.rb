module Vop

  class Service < ThingWithParams

    attr_reader :plugin, :name
    attr_reader :data
    attr_accessor :install_blocks

    def initialize(plugin, name)
      super()

      @plugin = plugin
      @name = name
      @data = {
        # TODO cleanup
        install: { },
        "install" => {}        
      }
      @install_blocks = [ ]
    end

    def to_s
      "Vop::Service #{name}"
    end

    def to_hash
      meta = { "name" => @name }
      @data.merge(meta)
    end

  end

end
