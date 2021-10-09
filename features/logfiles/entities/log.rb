key "path"

on :machine

entity do |machine|
  result = []
  machine.detect_services.map do |service_name|
    service = @op.known_services[service_name]
    if service["logfiles"]
      service["logfiles"].each do |path, options|
        if machine.file_exists(path)
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
