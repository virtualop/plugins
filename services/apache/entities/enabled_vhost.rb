key "name"

on :machine

invalidate do |machine|
  machine.list_files!("/etc/apache2/sites-enabled")
end

entity do |machine|
  machine.list_files("/etc/apache2/sites-enabled").map do |file|
    (source, target) = file["name"].split("->").map(&:strip)
    {
      "name" => source,
      "target" => target,
      "enabled" => true
    }
  end
end
