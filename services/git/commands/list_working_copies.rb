param! :machine

run do |machine|
  vop_root = "#{ENV["HOME"]}/projects/virtualop"

  dirs = machine.list_files(dir: vop_root, extra_filter: "d")
  dirs.map do |file|
    x = file["name"]
    hash = {
      name: x,
      path: "#{vop_root}/#{x}",
    }
    hash[:html_name] = hash[:path].gsub("/", "-")

    hash
  end.select do |x|
    machine.file_exists("#{x[:path]}/.git")
  end
end
