execute do |params|
  
  @op.flush_cache()
  
  machines = if @plugin.config.has_key? 'target'
    config_string('target').map do |target|
      @op.machines_in_group target
    end.flatten
  else
    @op.list_machines
  end
  
  machines.each do |m|
    @op.with_machine(m["name"]) do |machine|
      machine.crawl_machine
    end
  end
  
  machines.size
end
