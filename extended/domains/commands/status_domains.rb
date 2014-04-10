description "aggregates the data from +list_domains+ into one line per domain and columns for status"

param :machine

add_columns [ :domain, :service, :config, :reverse_proxy ]

on_machine do |machine, params|
  by_domain = {}
  machine.list_domains.each do |row|
    by_domain[row['domain']] ||= []
    by_domain[row['domain']] << row
  end
  
  result = []
  by_domain.each do |domain, rows|
    contribs = rows.pick(:contributed_by)
    result << {
      'domain' => domain,
      'service' => rows.map { |x| x['service'] }.select { |x| x }.join(','),
      'config' => contribs.include?('list_configured_vhosts'),
      'reverse_proxy' => contribs.include?('list_domains_in_reverse_proxy')
    }
  end
  
  result
end
