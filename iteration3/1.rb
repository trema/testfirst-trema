# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "..", "..", "trema", "spec", "spec_helper")


class RepeaterHub < Trema::Controller
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
    }.run(RepeaterHub) {
      vhost("host1").send_packet "host2"

      pending("あとで実装する")

      vhost("host2").stats(:rx).should have(1).packets
      vhost("host3").stats(:rx).should have(1).packets
    }
  end

  
  it "should receive a packet_in message" do
    network {
      vswitch("switch") { dpid "0xabc" }

      vhost("host1") { promisc "on" }
      vhost("host2") { promisc "on" }
      vhost("host3") { promisc "on" }
      
      link "switch", "host1"
      link "switch", "host2"
      link "switch", "host3"
    }.run(RepeaterHub) {
      controller("RepeaterHub").should_receive(:packet_in).with do |dpid, m|
        dpid.should == 0xabc
      end

      send_packets "host1", "host2"
    }
  end
end
