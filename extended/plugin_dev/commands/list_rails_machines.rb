add_columns [ :name, :state, :owner, :environment ]

execute do |params|
  Machine.all.map { |x|
    {
      'name' => x.name,
      'state' => x.state,
      'owner' => x.owner,
      'environment' => x.environment
    }
  }
end
