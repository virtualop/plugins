param! "name", multi: true
param "type", default: "host"

run do |params, type|
  machines = params["name"].map do |name|
    {
      "name" => name,
      "type" => type
    }
  end
  @op.machines_found("machines" => machines)
end
