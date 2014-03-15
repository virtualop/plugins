execute do |params|
  result = nil
  
  @op.with_machine('self') do |vop|
    candidates = vop.list_services.select { |x| 
      x['full_name'].split('/').first == 'virtualop_webapp' &&
      x['is_startable'].to_s == 'true' &&
      @op.status_service('machine' => 'self', 'service' => x['full_name']).to_s == 'true'       
    }
    
    raise "no virtualop webapp service found" if candidates.size == 0
    raise "more than one potential service found - bailing out" if candidates.size > 1
    
    result = candidates.first 
  end
  
  result['full_name']
end
