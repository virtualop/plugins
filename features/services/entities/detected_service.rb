on :machine

contribute to: "services"

entity do |machine|
  machine = @op.machines[machine]
  machine.detect_services.map do |x|
    {
      "name" => x
    }
  end
end
