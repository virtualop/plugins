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
    db_dump_name_base = "#{dump_name}-#{db.name}"
    db_dump_name = "#{db_dump_name_base}.dmp"
    machine.sudo "mysqldump #{db.name} > #{dump_dir}/#{db_dump_name}"
    machine.ssh "cd #{dump_dir} && tar -czf #{db_dump_name_base}.tgz #{db_dump_name} && rm #{db_dump_name}"
  end

  machine.list_dumps!
end
