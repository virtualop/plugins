execute do |params|
  @op.list_rails_machines.select { |x| 
    x['environment'] &&
    x['environment'] == 'development'  
  }
end