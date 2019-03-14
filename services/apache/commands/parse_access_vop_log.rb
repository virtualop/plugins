param! "data", "the access vop log lines that should be read", multi: true

dont_log

run do |data|
  data.map do |line|
    line.strip!
    line.chomp!

    entry = nil

    $logger.debug "parsing >>#{line}<<"

    # 1552503303 [13/Mar/2019:19:55:03 +0100] dev.santafe.virtualop.org 192.168.123.1 88.130.56.76 200 146b 7662micros - "GET /assets/global.self-dc9b8fccee74d6708a00004df916632e584d286d4c62f5efc8c36f936fc8809c.js?body=1 HTTP/1.1" "http://dev.santafe.virtualop.org/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0"

    #           0                    1       2           3                                 4       5       6             7        8       9          10          11         12          13
    result = /^([\d\.]+)\s+\[.+\]\s+(\S+)\s+([\d\.]+)\s+((?:[\d\.\w]+,\s)*[\d+\.\w]+|-)\s+(\d+)\s+(.+)b\s+(\d+)micros\s+(\S+)\s+"(\w+)\s+(\S+?)(?:\?(.+))?(?:\s+(.+))?"\s+"([^"]+)"\s+"([^"]+)"$/.match(line)
    if result
      entry = {
        timestamp: result.captures[0],
        http_host: result.captures[1],
        remote_ip: result.captures[2],
        x_forwarded_for: result.captures[3],
        return_code: result.captures[4],
        response_size_bytes: result.captures[5],
        response_time_microsecs: result.captures[6],
        http_method: result.captures[8],
        request_path: result.captures[9],
        query_string: result.captures[10],
        http_version: result.captures[11],
        referrer: result.captures[12],
        user_agent: result.captures[13]
      }

      if entry
        # for the source ip: if x-forwarded-for is set, it's the last part of
        # x-forwarded-for that is not "unknown", otherwise it's the remote_ip
        if (entry[:x_forwarded_for]) then
          parts = entry[:x_forwarded_for].split(", ")
          # TODO take the first part of the x_forwarded_for header
          parts.reverse.each do |part|
            if part != "unknown" && part != "unknownn" # this wasn't me...
              entry[:source_ip] = part
              break
            end
          end
        else
          entry[:source_ip] = entry[:remote_ip]
        end
      end
    else
      # TODO maybe count unparseable lines?
      $logger.warn "cannot parse : #{line}"
    end

    entry
  end
end
