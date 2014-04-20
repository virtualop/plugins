description "this road lies madness"

contributes_to :list_widgets

execute do |params|
  webapp_widgets_path = "#{Rails.root.to_s}/app/views/home/widgets/"
  
  result = []
  
  @op.with_machine('self') do |machine|
    areas = %w|north main fix toolbar|
    areas.each do |area|
      area_path = "#{webapp_widgets_path}/#{area}"
      next unless machine.file_exists area_path
      machine.list_files(area_path).each do |file|
        /_(.+)\.erb$/ =~ file or next
        result << {
          'name' => $1,
          'position' => area,
          'template' => "#{area_path}/#{file}"
        }
      end
    end
  end
  
  result
end
