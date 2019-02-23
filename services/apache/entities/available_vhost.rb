key "name"

on :machine

invalidate do |machine|
  @op.machines[machine].list_files!("/etc/apache2/sites-available")
end

entity do |machine|
  @op.machines[machine].list_files("/etc/apache2/sites-available").map do |file|
    {
      "name" => file["name"],
      "enabled" => false
    }
  end
end
