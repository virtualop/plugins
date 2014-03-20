def hetzner_account_dropdir
    config_string("hetzner_account_dropdir", "/etc/vop/hetzner_accounts.d")
  end

def param_hetzner_account(options = {})
  param_hetzner_account_without_context(:autofill_context_key => "hetzner_account")
end

def param_hetzner_account_without_context(options = {})
  merge_options_with_defaults(options, 
    :mandatory => true,
    :lookup_method => lambda do
      @op.list_hetzner_accounts.map do |account|
        account["alias"]
      end
    end
  )
  RHCP::CommandParam.new("hetzner_account", "the hetzner account that should be used by default", options)
end

def param_hetzner_alias(options = {})
  param_hetzner_alias_without_context(:autofill_context_key => 'hetzner_account')
end

def param_hetzner_alias_without_context(options = {})
  merge_options_with_defaults(options, 
    :mandatory => true,
    :lookup_method => lambda do
      @op.list_hetzner_accounts.map do |account|
        account["alias"]
      end
    end
  )
  RHCP::CommandParam.new("alias", "the hetzner account that should be used by default", options)
end
