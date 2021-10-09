param! :machine

contribute to: "ssh_options" do |machine|
  machine.metadata.map do |key, value|
    next unless matched = /^ssh.(.+)/.match(key)
    [
      matched.captures.first,
      value
    ]
  end.compact.to_h if machine&.metadata&.any?
end
