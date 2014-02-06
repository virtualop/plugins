description "lists all configured subversion servers"

mark_as_read_only

add_columns [ "alias", "url", "user" ]

execute do |params|
  @plugin.state[:drop_dir].read_local_dropdir.select { |x| x["enabled"] }.sort_by { |x| x["alias"] }
end