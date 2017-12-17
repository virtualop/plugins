contribute to: "scan_machines" do
  result = []

  @op.hetzner_accounts.each do |account|
    result += account.hetzner_server_list
  end

  result
end
