param! :machine
param! "file", default_param: true
param "raw", default: false

run do |machine, file, raw|
  result = {}
  machine.read_file("file" => file).lines.each do |line|
    line.strip!

    if /^\s*([^#]+?\S+)\s+(.+)/ =~ line
      (key, value) = [$1, $2]

      case key
      when "ProxyPass"
        (path, url) = value.split(" ")

        result["proxy"] = {
          "path" => path,
          "url" => url
        }

        if /^http(s?)\:\/\/([^\/]+)\/$/.match(url)
          result["proxy"]["host"] = $2
        end
      when "ServerName"
        result["domain"] = value
      when "DocumentRoot"
        result["web_root"] = value
      # <VirtualHost : *:443>
      when "<VirtualHost"
        if value =~ /\:443/
          result["https"] = true
        end
      end

      if raw
        result[key] = value
      end
    end
  end

  result
end
