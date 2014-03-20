def yaml_failover_row_to_rhcp(host, data_row)
  result = nil
  if data_row.has_key?('failover')
    result = data_row['failover']
    [ "ip", "server_ip", "active_server_ip" ].each do |thing|
      dig_result = host.dig({"query" => result[thing]})
      result[thing + "_lookup"] = dig_result.first["hostname"]
    end
  end
  result
end

def mark_result_failover_ips(command)
  command.result_hints[:display_type] = "table"
  command.result_hints[:overview_columns] = [ "ip", "ip_lookup", "server_ip", "server_ip_lookup", "active_server_ip", "active_server_ip_lookup", "netmask" ]
  command.result_hints[:column_titles] = [ "ip", "ip_lookup", "server_ip", "server_ip_lookup", "active_server_ip", "active_server_ip_lookup", "netmask" ]
end
