param! :machine
param :database, multi: true

run do |machine, database|
  dump_dir = machine.home + "/dumps"
  timestamp = Time.now().strftime("%Y%m%d%H%M%S")
  dump_name = "db-backup.#{machine.name}.#{timestamp}"

  unless machine.file_exists dump_dir
    machine.mkdirs dump_dir
  end

  if database.nil? || database.size == 0
    database = machine.user_databases    
  end

  database.each do |db|
    machine.sudo "mysqldump #{db.name} > #{dump_dir}/#{dump_name}.dmp"
    machine.ssh "cd #{dump_dir} && tar -czf #{dump_name}.tgz #{dump_name}.dmp && rm #{dump_name}.dmp"
  end

  machine.list_dumps!
end
