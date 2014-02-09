description "returns projects/repos read from github"

github_params

mark_as_read_only

add_columns [ :full_name, :ssh_url, :private ]

with_contributions do |result, params|
  result
end
