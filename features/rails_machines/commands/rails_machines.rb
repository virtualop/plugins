read_only

#contribute to: "machines" do
run do
  Machine.all.map(&:attributes)
end
