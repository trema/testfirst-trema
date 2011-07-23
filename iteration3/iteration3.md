!SLIDE master
# Iteration #3 #################################################################
## "Packet-in"


!SLIDE full-page-image

![TODO](todo.jpg "TODO")


!SLIDE bullets small
# Breakdown ####################################################################

* <b>"RepeaterHub should receive a packet_in message"</b>
* ==
* <i>Given</i>: one switch, and three hosts are connected to it
* <i>When</i>: Host #1 sends a packet to host #2
* <i>Then</i>: the packet_in message should be delivered to the controller


!SLIDE smaller
# Expectation ##################################################################

	@@@ ruby
	describe RepeaterHub do
	  it "should receive a packet_in message" do
	    network {
	      # ...
	    }.run(RepeaterHub) {
	      # Expectation:
	      #  packet_in message from 0xabc should be delivered to
	      #  the controller only once
	      controller("RepeaterHub").should_receive(:packet_in).with do |dpid, m|
	        dpid.should == 0xabc
	      end

	      send_packets "host1", "host2"
	    }
	  end
	end
	
	# => SUCCESS


!SLIDE bullets small
# Message handlers ############################################################

* Controller#packet_in(datapath_id, message)
* Controller#flow_removed(datapath_id, message)
* Controller#switch_disconnected(datapath_id)
* Controller#port_status(datapath_id, message)
* Controller#stats_reply(datapath_id, message)
* Controller#openflow_error(datapath_id, message)
* (See src/examples/dumper.rb for full list)


!SLIDE smaller
# Don't Repeat Yourself ########################################################

	@@@ ruby
	describe RepeaterHub do
	  # common setup here
	  around do |example|  # `example' is binded to each "it" block
	    network {
	      ...
	    }.run(RepeaterHub) {
	      example.run  # run "it" block
	    }
	  end
	
	  it "should #packet_in" do
	    controller("RepeaterHub").should_receive(:packet_in).with do |m, dpid|
	      dpid.should == 0xabc
	    end
	
	    send_packets "host1", "host2"
	  end
	
	  it "should flood incoming packets to every other port" do
	    send_packets "host1", "host2"
	
	    pending("Implement later")
	    vhost("host2").stats(:rx).should have(1).packets
	    vhost("host3").stats(:rx).should have(1).packets
	  end
	end
		
	# => SUCCESS


!SLIDE full-page-image

![TODO](todo1.jpg "TODO")


!SLIDE full-page-image

![シーケンス図](sequence.jpg "シーケンス図")
