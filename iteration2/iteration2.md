!SLIDE
# Iteration #2 #################################################################
## "Flood incoming packets to every other port"


!SLIDE bullets small
# Let's write down unit tests ##################################################

## You can describe the flooding feature of RepeaterHub as follows:

	@@@ ruby
	describe RepeaterHub do
	  it "should flood incoming packets to every other port"
	end

* "it" == an instance of RepeaterHub
* It is still just a placeholder, because the body of this feature is not written yet.


!SLIDE commandline small
# Run ##########################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	
	RepeaterHub
	  should flood incoming packets to every other port (PENDING: Not Yet Implemented)
	
	Pending:
	  RepeaterHub should flood incoming packets to every other port
	    # Not Yet Implemented
	    # ./spec/repeater-hub_spec.rb:9
	
	Finished in 0.00024 seconds
	1 example, 0 failures, 1 pending
	
	
	=> PENDING (Not Yet Implemented)


!SLIDE bullets small
# It (RSpec) ###################################################################

	@@@ ruby
	describe "Hello Trema" do
	  it 'should be a String' do
	    "Hello Trema".should be_a(String)
	  end

	  it 'should not == "Hello Frinfon"' do
	    "Hello Trema".should_not == "Hello Frinfon"
	  end
	end

	# =>
	#   Hello Trema
	#     should be a String
	#     should not equal to "Hello Frinfon"


* Each "it" corresponds to a feature
* Test codes within the "it" block
* You can get a human-readable spec output by running RSpec scripts


!SLIDE bullets small
# Breakdown ####################################################################

* <b>"Controller should flood incoming packets to every other port"</b>
* ==
* <i>Given</i>: one switch, and three hosts are connected to it
* <i>When</i>: Host #1 sends a packet to host #2
* <i>Then</i>: Host #2 and #3 should receive the packet


!SLIDE small
# Given ########################################################################

	@@@ ruby
	describe RepeaterHub do
	  it "should flood incoming packets to every other port" do

	    # ************** Given **************
	    network {
	      # A switch
	      vswitch("switch") { dpid "0xabc" }

	      # Three hosts
	      vhost("host1") { promisc "on" }
	      vhost("host2") { promisc "on" }
	      vhost("host3") { promisc "on" }

	      # Connect these hosts to the switch
	      link "switch", "host1"
	      link "switch", "host2"
	      link "switch", "host3"
	    }
	  end
	end

## Note that the syntax is fully compatible with Trema's network DSL


!SLIDE small
# Network DSL for RSpec ########################################################

	@@@ ruby
	#
	# Describe test environment in network { ... } block
	#
	network {
	  # Virtual switches
	  vswitch("name") { options }
	
	  # Virtual hosts
	  vhost("name") { options }
	
	  # Virtual links
	  link "peer#1", "peer#2"
	}


!SLIDE smaller
# Given, <b>When</b> ###########################################################

	@@@ ruby
	describe RepeaterHub do
	  it "should flood incoming packets to every other port" do
	
	    # ************** Given **************
	    network {
	      ...
	
	    # ************** When **************
	    }.run(RepeaterHub) { # Run a RepeaterHub in the Given network
	      # Host #1 sends a packet to host #2
	      vhost("host1").send_packet "host2"
	    }
	  end
	end


!SLIDE bullets small
# "When" API ###################################################################

	@@@ ruby
	network {
	  # ...
	}.run(ControllerClass) {
	  # vswitch("name").method
	  # vhost("name").method
	  # link("peer1", "peer2").method
	}

* Components defined in the network block (vswitch, vhost and link) are wrapped as Ruby objects in the "When" block.
* In the "When" block, you can invoke any  method of these wrapped objects


!SLIDE small
# "When" Example ###############################################################

	@@@ ruby
	# Send 1,000 packets from host1 to host2
	vhost("host1").send_packet "host2", :n_pkts => 1000
	
	# Send packets from host1 to host2 for 5 seconds with pps = 10
	vhost("host1").send_packet "host2", :pps => 10, :duration => 5
	
	# (Other options are also available "./trema help send_packets")
	
	
	# Fault injection
	link("host1","host2").down
	link("host1","host2").up
	
	# Etc, etc...


!SLIDE commandline small
# Test result ##################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	
	RepeaterHub
	  should flood incoming packets to every other port (FAILED - 1)
	
	Failures:
	
	  1) RepeaterHub should flood incoming packets to every other port
	     Failure/Error: network {
	     RuntimeError:
	       RepeaterHub is not a subclass of Trema::Controller
	     # ./spec/repeater-hub_spec.rb:11
	
	Finished in 0.07034 seconds
	1 example, 1 failure
	
	
	=> FAIL (RepeaterHub is not a subclass of Trema::Controller)


!SLIDE small
# Quick fix ####################################################################

	@@@ ruby
	# Inherit from Trema::Controller class
	class RepeaterHub < Trema::Controller
	end
	

	describe RepeaterHub do
	  it "should flood incoming packets to every other port" do
	    network {
	      # ...
	    }.run(RepeaterHub) {
	      # ...
	    }
	  end
	end
	
	
	#=> SUCCESS


!SLIDE smaller
# Given, When, <b>Then</b> #####################################################

	@@@ ruby
	describe RepeaterHub do
	  it "should flood incoming packets to every other port" do
	
	    # ************** Given **************
	    network {
	      # ...
	
	    # ************** When **************
	    }.run(RepeaterHub) {
	      vhost("host1").send_packet "host2"

	    # ************** Then **************
	      vhost("host2").stats(:rx).should have(1).packets
	      vhost("host3").stats(:rx).should have(1).packets
	    }
	  end
	end


!SLIDE commandline small
# Run ##########################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	
	RepeaterHub
	  should flood incoming packets to every other port (FAILED - 1)
	
	Failures:
	
	  1) RepeaterHub should flood incoming packets to every other port
	     Failure/Error: vhost("host2").stats(:rx).should have( 1 ).packets
	       expected 1 packets, got 0
	     # ./spec/repeater-hub_spec.rb:24
	
	Finished in 4.18 seconds
	1 example, 1 failure
	
	
	=> FAIL (expected 1 packets, got 0)


!SLIDE bullets small
# Matchers #####################################################################


	@@@ ruby
	vhost("host2").stats(:rx).should have(1).packets
	
	
	# vs.
	
	
	vhost("host2").stats(:rx).packets.size.should == 1


!SLIDE small
# Matchers (Error Message) #####################################################

	@@@ ruby
	vhost("host2").stats(:rx).should have(1).packets
	#=> expected 1 packets, got 0
	
	
	# vs.
	
	
	vhost("host2").stats(:rx).packets.size.should == 1
	#=> expected: 1
	#        got: 0 (using ==)


!SLIDE bullets small
# ... Stuck? ###################################################################

* Let's divide into smaller tests and implement one-by-one
* For now, mark this test as "pending" and give it the lowest priority


!SLIDE smaller
# Pending ######################################################################

	@@@ ruby
	describe RepeaterHub do
	  it "should flood incoming packets to every other port" do
	    network {
	      # ...
	    }.run(RepeaterHub) {
	      send_packets "host1", "host2"
	
	      # mark as pending
	      pending("Implement later")
	
	      vhost("host2").stats(:rx).should have(1).packets
	      vhost("host3").stats(:rx).should have(1).packets
	    }
	  end
	end


!SLIDE commandline small
# Run ##########################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	
	RepeaterHub
	  should flood incoming packets to every other port (PENDING: Implement later)
	
	Pending:
	  RepeaterHub should flood incoming packets to every other port
	    # Implement later
	    # ./spec/repeater-hub_spec.rb:10
	
	Finished in 3.99 seconds
	1 example, 0 failures, 1 pending


!SLIDE full-page-image

![シーケンス図](sequence.jpg "シーケンス図")
