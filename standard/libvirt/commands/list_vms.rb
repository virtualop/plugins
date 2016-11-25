param! 'machine'

#contribute :to => 'machine' do |machine|
run do |machine|
  output = machine.ssh 'virsh list --all'

  data = output.strip.lines[2,output.length-1]
  data.map do |line|
    (unused_id, name, *state) = line.strip.split
    {
      name: name,
      state: state.join(" ")
    }
  end
end
