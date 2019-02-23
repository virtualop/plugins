run do
  @op.machines.select do |x|
    ! x.data["seen_at"].nil? &&
    (DateTime.parse(x.data["seen_at"]).to_i < Time.now.to_i - (7 * 24 * 3600))
  end
end
