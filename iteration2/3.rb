require File.join(File.dirname(__FILE__), "..", "..", "trema", "spec", "spec_helper")


class RepeaterHub
end


describe RepeaterHub do
  it "should flood incoming packets to every other port" do
    network {
      vswitch("switch") { dpid "0xabc" }

      vhost("host1") { promisc "on" }
      vhost("host2") { promisc "on" }
      vhost("host3") { promisc "on" }
      
      link "switch", "host1"
      link "switch", "host2"
      link "switch", "host3"
    }
  end
end
