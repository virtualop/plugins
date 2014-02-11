param! 'data', 'the data lines that should be parsed', :allows_multiple_values => true

display_type :list

execute do |params|
  params['data'].map do |line|
    entry = nil
    
    line.strip! and line.chomp!


    #[Sun Feb 09 19:44:41 2014] [error] (111)Connection refused: proxy: HTTP: attempt to connect to 127.0.0.1:3000 (127.0.0.1) failed
    #[Sun Feb 09 12:51:34 2014] [error] [client 10.60.10.2] File does not exist: /var/www/html/owncloud/favicon.ico
    #[Sun Feb 09 11:55:17 2014] [error] [client 10.60.10.2] PHP Fatal error:  Unknown: Failed opening required '/var/www/html/owncloud/info.php' (include_path='.:/usr/share/pear:/usr/share/php') in Unknown on line 0
    matched = /^\[([^\]]+)\]\s+\[(\w+)\]\s+(.+)$/.match(line)
    if matched then
      entry = {
        :log_ts => Time.at(DateTime.parse(matched.captures[0]).to_time.to_i).utc,
        :log_level => matched.captures[1],
        :message => matched.captures[2]
      }
    end
    
    entry
  end
end