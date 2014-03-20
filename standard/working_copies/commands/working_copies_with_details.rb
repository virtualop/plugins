param :machine

mark_as_read_only

add_columns [ :path, :name, :type ]

include_for_crawling

on_machine do |machine, params|
  machine.list_working_copies.map do |x|
    machine.working_copy_details x['name']
  end.select { |x| x['project'] }.sort_by { |x| x['project'] }
end
