description "when a new user signs up, DNS entries are created so that there's a wildcard domain like *.$user.dev.virtualop.org (or whatever basedomain you are working on)"

contributes_to :new_user_async

param! 'login'

accept_extra_params

execute do |params|
  user = params['login']
  raise 'no user?' unless user
  
  domain = config_string('domain')
  user_domain = @op.user_domain
  
  if config_string('powerdns_machine', '') != ''
    @op.comment "DNS for new user #{user} : #{user_domain}..."
    @op.with_machine(config_string('powerdns_machine')) do |powerdns|
      powerdns.add_domain_record(
        'domain' => config_string('domain'),
        'name' => user_domain,
        'type' => 'CNAME',
        'content' => "#{domain}."
      )
      powerdns.add_domain_record(
        'domain' => config_string('domain'),
        'name' => "*.#{user_domain}",
        'type' => 'CNAME',
        'content' => "#{domain}."
      )
    end
    @op.comment "DNS complete : #{user_domain}"
  end
end
