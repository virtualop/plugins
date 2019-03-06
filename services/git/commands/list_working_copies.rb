param! :machine

run do |machine|
  vop_root = "#{ENV["HOME"]}/projects/virtualop"

  working_copy_names = %w|vop plugins services web virtualop_website|
  working_copy_names.map do |x|
    hash = {
      name: x,
      path: "#{vop_root}/#{x}",
    }
    hash[:html_name] = hash[:path].gsub("/", "-")
    hash
  end
end
