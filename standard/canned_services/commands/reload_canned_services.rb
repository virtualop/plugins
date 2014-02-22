contributes_to :plugin_list_changed

param! 'plugins', 'refreshed plugins list', :allows_multiple_values => true

execute do |params|
  @op.cache_bomb
  @op.list_canned_services
end
