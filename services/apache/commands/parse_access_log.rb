param! "data", "the access log lines that should be read", multi: true

show columns: %w|remote_ip timestamp request status|

run do |data|
  data.map do |line|
    line.strip!
    line.chomp!

    entry = nil

    $logger.debug "parsing >>#{line}<<"

    # 192.168.122.75 - - [01/Jul/2018:17:42:11 +0200] "GET /assets/footer.self-93db14d7dcc90f201c632e9a5f26d7e725599a4201214d7a1bf79539c16aa84b.js?body=1 HTTP/1.1" \
    #   200 711 "http://vop31.santafe.virtualop.org/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0"
    result = /([\d\.]+)\s+(\S+)\s+(\S+)\s+\[([^\]]+)\]\s+\"([^\"]+)\"\s+(\d{3})\s+(\d+)\s+\"([^\"]+)\"\s+\"([^\"]+)\"/.match(line)
    if result
      entry = {
        remote_ip: result.captures[0],
        timestamp: result.captures[3],
        request: result.captures[4],
        status: result.captures[5],
        bytes: result.captures[6],
        referrer: result.captures[7],
        user_agent: result.captures[8]
      }

      # parse timestamp
      apache_timestamp = entry[:timestamp]
      if matched = /(\d+\/\w+\/\d{4}):([\d:]+)\s+([\+\d]+)/.match(apache_timestamp)
        parseable = matched.captures[0] + " " + matched.captures[1] + " " + matched.captures[2]
        timestamp = DateTime.parse(parseable)
        entry[:timestamp_unix] = timestamp.strftime("%s").to_i
      else
        $logger.warn("unexpected timestamp format: '#{apache_timestamp}'")
      end
    else
      # TODO maybe count unparseable lines?
    end

    entry
  end
end
