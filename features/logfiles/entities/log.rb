key "path"

on :machine

entity do |machine|
  m = @op.machines[machine]

  result = []
  m.detect_services.map do |service_name|
    service = @op.services[service_name]
    if service["logfiles"]
      service["logfiles"].each do |path, options|
        if m.file_exists(path)
          result << {
            "source" => service_name,
            "path" => path,
            "parser" => options["parser"]
          }
        end
      end
    end
  end
  result
end
