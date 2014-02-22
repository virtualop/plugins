add_columns [ :name, :type ]

with_contributions do |result, params|
  result << { 'name' => 'xop_apache', 'type' => 'access_log' }
  result << { 'name' => 'apache_error', 'type' => 'server_log' }
  result << { 'name' => 'log4j', 'type' => 'server_log' }
  result << { 'name' => 'jboss', 'type' => 'server_log' }
  result << { 'name' => 'ruby_logger', 'type' => 'server_log' }
  result << { 'name' => 'slapd_access', 'type' => 'access_log' }
  
  result
end