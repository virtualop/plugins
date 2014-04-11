description "when a user account is deleted, the DNS records need to be cleaned up"

contributes_to :user_deleted_async

param! 'login'

accept_extra_params

execute do |params|
  user = params['login']
  raise 'no user?' unless user
  
  domain = config_string('domain')
  user_domain = "#{user}.#{domain}"
  
  if config_string('powerdns_machine', '') != ''
    @op.comment "DNS cleanup for user #{user} : #{user_domain}..."
    
    @op.with_machine(config_string('powerdns_machine')) do |powerdns|
      powerdns.delete_domain_records('domain' => domain, 'name' => "%#{user_domain}")
    end
    
    @op.comment "DNS cleanup complete : #{user_domain}..."
  end      
end  
