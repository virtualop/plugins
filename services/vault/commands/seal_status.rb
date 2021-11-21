show display_type: :raw

run do
  Vault.sys.seal_status.pretty_inspect
end
