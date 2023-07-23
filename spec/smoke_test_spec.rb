require "spec_helper"

RSpec.describe Vop do
  before(:example) do
    @vop = test_vop
  end

  it "knows about machines" do
    expect(@vop.commands.keys).to include "machines"
    expect(@vop.localhost).not_to be nil
    expect(@vop.machines["localhost"]).to be_an_instance_of Vop::Entity
  end

  it "can connect to machines" do
    @vop.machines["localhost"].test_ssh!
  end

  it "can do linuxy things" do
    machine = @vop.machines["localhost"]
    puts machine.distro
    puts machine.hostname
    puts machine.current_user
    puts machine.home
    pp machine.list_ip_addresses
    pp machine.listen_ports
    pp machine.memory
    pp machine.disk_free
  end
end
