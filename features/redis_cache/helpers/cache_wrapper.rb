module Vop

  class CacheWrapper

    attr_reader :data, :options, :timestamp

    def initialize(data, options = {}, timestamp = nil)
      @data = data
      @options = options
      @timestamp = timestamp || Time.now
    end

    def to_json
      begin
        JSON.generate({
          "options" => options,
          "data" => data,
          "timestamp" => @timestamp.to_i
        })
      rescue => detail
        $logger.warn("problem generating JSON : #{detail.message}")
        $logger.debug("offending payload : #{data.pretty_inspect}")
        raise detail
      end
    end

    def self.from_json string
      return if string.nil?
      payload = JSON.parse(string)
      self.new(payload["data"], payload["options"], payload["timestamp"])
    end

  end

end
