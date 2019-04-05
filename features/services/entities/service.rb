on :machine

entity do |machine|
  machine = @op.machines[machine]
  machine.detect_services.map do |x|
    {
      "name" => x
    }
  end
end
