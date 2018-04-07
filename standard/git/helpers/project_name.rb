def project_name_from_git_url(url)
  project_name = nil
  if /\/([^\/]+)\.git$/.match(url)
    project_name = $1
  end
  if project_name.nil?
    raise "could not determine project_name from Git URL: unexpected format #{url}"
  end
  project_name
end
