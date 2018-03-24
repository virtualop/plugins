require "rubygems"
require "find"
require "digest"

contribute to: "search_path" do |params|
  candidates = Gem::Specification.select { |spec| /^vop-plugins/ =~ spec.name }

  # checksum = Digest::MD5.new
  # candidates.map do |candidate|
  #   checksum << [ candidate.name, candidate.version ].join(":")
  # end
  # puts "gemspec md5 : #{checksum.hexdigest}"

  result = []

  candidates.each do |candidate|
    $logger.debug "inspecting #{candidate}"

    gem_path = candidate.full_gem_path

    Find.find(gem_path) do |path|
      # ignore hidden directories
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?.
          Find.prune
        else
          next
        end
      end

      if FileTest.file?(path)
        if File.basename(path).split('.').last == 'plugin'
          unless result.include? gem_path
            result << gem_path
          end
        end
      end
    end
  end

  #search_path = @op.show_search_path
  #result.delete_if { |x| search_path.include? x }

  result.map do |x|
    { "path" => x }
  end
end
