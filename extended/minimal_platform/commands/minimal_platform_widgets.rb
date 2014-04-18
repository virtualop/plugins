contributes_to :list_widgets

execute do |params|
  [
    {
      'name' => 'intro',
      'position' => 'main',
      'template' => @plugin.path + '/widgets/intro.erb'
    }
  ]
end