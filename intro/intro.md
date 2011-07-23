!SLIDE center
# Trema Tutorial ###############################################################
## Test-first openflow programming with Trema

<br />

## Yasuhito TAKAMIYA
## @yasuhito

<br />

## 6/9/2011

<br />
<br />

![Trema logo](trema.png)


!SLIDE bullets incremental small
# My personal CV  ##############################################################

* Many years of exeperience in HPC and middleware (Satoshi MATSUOKA Lab. @ Tokyo Tech)
* Only a few months of experience in OpenFlow (Trema)
* Keywords: MPI, Cluster, Grid, Cloud, Super Computing, Top500, TSUBAME @ Tokyo Tech
* Interests: Programming systems, agile and software testing in Ruby and C



!SLIDE bullets incremental small
# Today's Goal #################################################################

## Introduction to Trema with hands-on session

* How to develop in Trema
* Designing, testing and debugging using Trema framework
* <b>"Different from NOX, Beacon and others?"</b>


!SLIDE bullets incremental small
# Why Trema? ###################################################################

* ... because we write it in C and Ruby
* (NOX written in C++, Beacon written in Java)
* This is the main reason!


!SLIDE bullets small
# Difficulties of OpenFlow development #########################################

* Hard to setup execution environments
* (Lots of hardware switches, hosts, and cables...)
* Development environment in a box? (e.g., mininet)
* => Trema offers a similar emulation environment


!SLIDE bullets small
# Network emulation ############################################################

* Emulated execution environment in your laptop made by:
* virtual switches: Open vSwitch
* virtual hosts: phost (pseudo host)
* virtual links: vlink (ip command of Linux)

## You can construct your own topology using Ruby DSL (Domain Specific Language)


!SLIDE bullets small
# Network DSL ##################################################################

	@@@ ruby
	# virtual switches
	vswitch("switch1") { datapath_id "0x1" }
	vswitch("switch2") { datapath_id "0x2" }
	vswitch("switch3") { datapath_id "0x3" }
	vswitch("switch4") { datapath_id "0x4" }

	# virtual hosts
	vhost("host1")
	vhost("host2")
	vhost("host3")
	vhost("host4")
	
	# virtual links
	link "switch1", "host1"
	link "switch2", "host2"
	link "switch3", "host3"
	link "switch4", "host4"
	link "switch1", "switch2"
	link "switch2", "switch3"
	link "switch3", "switch4"


!SLIDE small
# Another difficulty of OpenFlow ###############################################

<br/>
<br/>

# <i>"OpenFlow programming</i>
# <i>==</i>
# <i>Distributed programming"</i>


!SLIDE full-page-image

![Network Mess](network_mess.png "Network Mess")


!SLIDE bullets small incremental
# OpenFlow == Distributed programming ##########################################

* Lots of switches, hosts, and links where
* each runs in its own memory space (in a separate hardware or a process),
* while changing its own state (flow table, stats etc.),
* and communicating intricately with each other
* <b>=> Need an aid from programming frameworks and tools!</b>


!SLIDE small
# Trema test framework #########################################################


!SLIDE full-page-image

![Trema framework](trema_framework.png "Trema framework")


!SLIDE bullets small
# Test framework (Ruby only) ###################################################

* Write network environment and controller, test using Ruby
* Setup and teardown of network environment
* Assertions and expectations over switches, hosts and your controller
* Fault injection such as intentional link-down, latencies and packet-drops etc.


!SLIDE bullets small
# Test code example ############################################################

	@@@ ruby
	# Test example: A unittest of MyController controller
	#
	#   The following tests that controller's packet_in handler
	#   is invoked when a packet is arrived.
	
	network { # Setup test environment
	  vswitch("switch") { datapath_id "0xabc" }
	
	  vhost("host1")
	  vhost("host2")

	  link "switch", "host1"
	  link "switch", "host2"
	}.run(MyController) { # Run tests
	  # Expectation over the controller
	  controller.should_receive(:packet_in)
	
	  # Send a test packet
	  send_packets "host1", "host2"
	}


!SLIDE bullets small
# Summary ######################################################################

## The integration of network emulation and test framework
## using Ruby enables developers to apply "well-known"
## testing techniques such as mocks, stubs and expectations
## to OpenFlow programming
