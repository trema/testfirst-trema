!SLIDE master bullets
# Design phase #################################################################

* The theme for this tutorial is "repeater-hub"
* By designing, testing and debugging repeater-hub with Trema, let's go through Trema framework.


!SLIDE full-page-image

![sequence diagram](sequence.jpg "sequence diagram")


!SLIDE bullets small incremental
# Analysis #####################################################################

* In order to test repeater-hub program, we need one switch and at least three hosts
* => How can we build a test environment? 

* The sequence diagram is a bit complex despite the simplicity of repeater-hub functions
* => How can we test each arrow in the sequence?


!SLIDE bullets small incremental
# Trema framework ##############################################################

* <b>Network DSL</b>
* Build emulation envrionments in your laptop and deploy onto real environments

* <b>Test framework</b>
* Describe and run unittests of each arrow in execution sequence

* <b>Trema Ruby library</b>
* Write DSL, tests and controller itself briefly and seamlessly


!SLIDE full-page-image
![dilbert](dilbert.gif "dilbert")
