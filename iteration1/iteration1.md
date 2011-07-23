!SLIDE master
# Iteration #1 #################################################################
## "Defining RepeaterHub class"


!SLIDE bullets small
# The first step ###############################################################

	@@@ ruby
	# ./spec/repeater-hub_spec.rb
	
	
	# load helper libraries for testing
	require File.join(File.dirname(__FILE__), "spec_helper")
	
	
	describe RepeaterHub do
	  # Write the spec description of repeater hub here
	  # The spec is executed as unittest
	end

* NOTE: syntactic details are explained later


!SLIDE commandline bullets small
# Test First ###################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	/home/yasuhito/play/trema/spec/repeater-hub_spec.rb:4: uninitialized constant RepeaterHub (NameError)
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load_spec_files'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `map'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load_spec_files'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/command_line.rb:18:in `run'
	  ...
	
	
	#=> FAIL ("RepeaterHub" is now known)

* No problem, because we did't implement the class yet.
* Let's add some code just enough to pass the test.


!SLIDE small
# Changes to pass the test #####################################################

	@@@ ruby
	require File.join( File.dirname( __FILE__ ), "spec_helper" )
	
	
	# Add an empty class definition
	class RepeaterHub
	end
	

	describe RepeaterHub do
	end


!SLIDE commandline bullets small
# Test again! ##################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	No examples found.
	
	Finished in 0.00003 seconds
	0 examples, 0 failures
	
	
	#=> SUCCESS

* We got the template of both RepeaterHub class and its test
* Successfully completed iteration #1


!SLIDE bullets small
# RSpec ########################################################################

	@@@ ruby
	# The spec of Car class
	describe Car do
	  car = Car.new
	  car.should respond_to(:run)
	  car.should respond_to(:stop)
	  car.should have(4).wheels
	end

* The de facto standard for unit test framework for Ruby
* Used in Rails and other well-known products
* Human-readable test DSL and its output (explained later)



!SLIDE bullets small
# Why Test First? ##############################################################

* OpenFlow programming is complicated, because it's a sort of distributed programming
* Unit-testing is helpful expecially for such a complicated problem
* Rubyists love tests and are used to it well
* => Trema offers the OpenFlow extension of RSpec (explained later)
