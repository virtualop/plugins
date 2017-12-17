param! "service"
param "section", default: :install

show display_type: :data

run do |service, section|
  result = @op.describe_service(service)
  if result.has_key? section
    result[section]
  else
    result
  end
end
