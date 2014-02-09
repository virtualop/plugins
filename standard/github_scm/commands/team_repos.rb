github_params

contributes_to :repos

mark_as_read_only

add_columns [ :full_name, :ssh_url, :private ]

execute do |params|
  result = []
  @op.list_orgs.each do |org|
    result += @op.list_repos_for_org('org' => org['login'])
  end
  result
end