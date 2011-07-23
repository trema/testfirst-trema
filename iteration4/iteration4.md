!SLIDE master
# Iteration #4 #################################################################
## "Flow-mod"


!SLIDE full-page-image

![TODO](todo.jpg "TODO")


!SLIDE bullets small
# Breakdown ####################################################################

* <b>"Controller should send a flow_mod message"</b>
* ==
* <i>Given</i>: one switch, and three hosts are connected to it
* <i>When</i>: Host #1 sends a packet to host #2
* <i>Then</i>: the controller sends a flow_mod message to the switch


!SLIDE smaller
# Test #########################################################################

	@@@ ruby
	it "should send a flow_mod message" do
	  controller("RepeaterHub").should_receive(:send_flow_mod_add).with(0xabc)
		
	  send_packets "host1", "host2"
	end
	
	# => FAIL!


!SLIDE small
# Sending a flow-mod ###########################################################

	@@@ ruby
	class RepeaterHub < Trema::Controller
	  def packet_in datapath_id, message
	    # An empty flow_mod (no match, no actions)
	    send_flow_mod_add datapath_id
	  end
	end
	
	# => SUCCESS


!SLIDE small
# Simplified incremental development ###########################################

## Add extra parameters to methods as you get to know more

	@@@ ruby
	# No match and no actions by default
	send_flow_mod_add datapath_id
	
	# Add a match
	send_flow_mod_add datapath_id, :match => match1
	
	# Add actions
	send_flow_mod_add datapath_id,
	                  :match => match1, :actions => [act1, act2]
	
	# Set idle_timeout (default = 0)
	send_flow_mod_add datapath_id,
	                  :idle_timeout = 60,
	                  :match => match1, :actions => [act1, act2]


!SLIDE small
# Test the number of flow entries ##############################################

	@@@ ruby
	# Testee is the switch
	describe "switch" do
	  it "should have one flow entry" do
	    send_packets "host1", "host2"

	    switch("switch").should have(1).flows
	  end
	end
	
	# => SUCCESS


!SLIDE small
# Flow-entry property ##########################################################

	@@@ ruby
	describe "switch" do
	  it "should have one flow entry" do
	    send_packets "host1", "host2"

	    switch("switch").should have(1).flows
	    switch("switch").flows.first.actions.should == "FLOOD"
	  end
	end
	
	# => FAIL
	#
	#  1) RepeaterHub switch should have one flow entry
	#     Failure/Error: switch("switch").flows.first.actions.should == "FLOOD"
	#       expected: "FLOOD"
	#            got: "drop" (using ==)


!SLIDE smaller
# Add actions ##################################################################

	@@@ ruby
	def packet_in message
	  send_flow_mod_add(
	    message.datapath_id,
	    :actions => ActionOutput.new(OFPP_FLOOD)
	  )
	end
	
	# => FAIL
	#  1) RepeaterHub should send a flow_mod message
	#     Failure/Error: network {
	#       #<RepeaterHub:0xb7420d94> received :send_flow_mod_add with unexpected arguments
	#         expected: (2748)
	#              got: (2748, {:actions=>#<Trema::ActionOutput:0xb741a368 @port=65531>})


!SLIDE smaller
# Fix broken test ##############################################################

	@@@ ruby
	it "should send a flow_mod message" do
	  controller("RepeaterHub").should_receive(:send_flow_mod_add)
	                           .with(0xabc, hash_including(:actions))
		
	  send_packets "host1", "host2"
	end
	
	# => SUCCESS


!SLIDE smaller
# Flow-entry property ##########################################################

	@@@ ruby
	  vhost("host1") { promisc "on"; ip "192.168.0.1" }
	  vhost("host2") { promisc "on"; ip "192.168.0.2" }
	  vhost("host3") { promisc "on"; ip "192.168.0.3" }
	  # ...
	
	describe "switch" do
	  it "should have one flow entry" do
	    send_packets "host1", "host2"

	    switch("switch").should have(1).flows
	    flow = switch("switch").flows.first
	    flow.actions.should == "FLOOD"
	    flow.nw_src.should == "192.168.0.1"
	    flow.nw_dst.should == "192.168.0.2"
	  end
	end
	
	# => FAIL
	#
	#  1) RepeaterHub switch should have one flow entry
	#     Failure/Error: flow.nw_src.should == "192.168.0.1"
	#       expected: "192.168.0.1"
	#            got: nil (using ==)


!SLIDE small
# Set match structure ##########################################################

	@@@ ruby
	class RepeaterHub < Trema::Controller
	  def packet_in datapath_id, message
	    send_flow_mod_add datapath_id,
	                      :match => ExactMatch.from(message),
	                      :actions => ActionOutput.new(OFPP_FLOOD)
	  end
	end
	
	# => SUCCESS


!SLIDE small
# ExactMatch.from() ############################################################

	@@@ ruby
	ExactMatch.from(message)
	
	# vs.
	
	Match.new(
	  :in_port = message.in_port,
	  :nw_src => message.nw_src,
	  :nw_dst => message.nw_dst,
	  :tp_src => message.tp_src,
	  :tp_dst => message.tp_dst,
	  :dl_src => message.dl_src,
	  :dl_dst => message.dl_dst,
	    ...
	)	      	


!SLIDE full-page-image

![TODO](todo1.jpg "TODO")


!SLIDE full-page-image

![シーケンス図](sequence.jpg "シーケンス図")
