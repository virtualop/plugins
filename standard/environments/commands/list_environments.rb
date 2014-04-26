param 'full'

execute do |params|
  data = {
    'dev' => 'development',
    'stg' => 'staging',
    'prd' => 'production'
  }
  if params['full']
    data
  else
    data.values
  end
end