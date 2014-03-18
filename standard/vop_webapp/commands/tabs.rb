param :machine

add_columns [ :name, :title ]

on_machine do |machine, params|
  @plugin.state[:tabs]
end
