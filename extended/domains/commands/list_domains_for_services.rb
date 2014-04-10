description "returns domains found in the configuration of installed services"

param :machine

contributes_to :list_domains

mark_as_read_only

on_machine do |machine, params|
  result = []
  
  machine.list_services.each do |service|
    detail = machine.service_details(service['full_name'])
    if (detail['domain'])
      domain = detail['domain']
      domains = domain.is_a?(Array) ? domain : [ domain ]
      result += domains.map do |x| 
        { 
          'domain' => x,
          'service'=> service['full_name']
        }
      end
    end
  end
  
  result
end
