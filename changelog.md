## [0.0.1] – 2019-03-12
### Added
 - Max reset the software in the Raspberry Pi, wired the Pi back into our 3D-printed housing, and reconnected it to our solenoids.
 - Max got Zerotier connectivity working between the Raspberry Pi and both his and Shawn's laptops.
 - Both Max and Shawn can now remotely connect to and control the Raspberry Pi from their laptops.
 - Max confirmed that simple classification OSC messages from Wekinator can be recieved by the Raspberry Pi.
 
## [0.0.2] – 2019-03-15
### Added
 - Shawn rewrote the Processing code on the Raspberry Pi to accept DTW wand gestures from Wekinator, as opposed to simple classification OSC messages.
 - Shawn created, trained, and saved a Wekinator project that reliably recognizes "up" and "down" spells from a wand. 
 - Shawn confirmed that wand spells can in fact cause our solenoids to fire.
 
## [0.0.3] – 2019-03-19
### Added
 - Both Max and Shawn tested our solenoid system on the elevator in Atlas, and all the components work with one another, but the solenoids just are not powerful enough to actually press the elevator buttons!
 - Shawn uploaded all relevant code files to GitHub and created this changelog file.
 - Both Max and Shawn recorded this progress update video: https://youtu.be/D2E1a5-l_-8

## [0.0.4] – 2019-04-03
### Added
 - Shawn added a voice recognition feature to the software. From now on, the elevator will only be called if both the gesture and the corresponding outspoken spell are correctly recognized. 
 - Max researched alternatives to the previously tested solenoids. Other customers of that solenoid type also reported that the solenoid only produces about half the force than stated in the datasheet. Alternatives are A: stronger solenoids B: electric linear motor or C: a pneumatic system. The specifications of each option can be found in the proposal document. All options drive costs and complexity of the system while reducing the mobility.
 - Both Shawn and Max will discuss hacking options with facility management on 04/04/2019.
 - Shawn recorded this progress update video: https://youtu.be/4teWFxSjB8g

## [0.0.5] – 2019-04-09
### Added
 - Shawn altered the voice-to-text script to send OSC messages when key spell phrases are in the returned text, as opposed to the returned text matching the phrases exactly
 - Max built a linear actuator out of LEGO parts that is finally powerful enough to press elevator buttons
 - Both Shawn and Max recorded this progress update video: https://youtu.be/d8HVFMx6nRo
 
## [0.0.6] – 2019-04-16
### Added
 - Shawn added a Python script that controls Wekinator with voice commands. Specifically, it can control starting/stopping running and recording DTW examples. He also wrote a different script that walks the user through training an "up" gesture without the need for voice commands.
 - Max designed and laser cut acrylic sheets for our hardware. Further iterations of the hardware to avoid "pushing itself off the wall" have been made. Gears have been modified to activate both buttons with one motor.
 - Both Shawn and Max received the BrickPi3 and set it up.
 - Shawn got the previous software working with the new LEGO hardware (including Zerotier, VNC connection and LEGO motor activation).
 - Both Shawn and Max recorded this progress update video: https://youtu.be/z2Na-lmQrTQ
 
## [0.0.7] – 2019-04-25
### Added
 - Shawn finished the wand motion training/incantation changing user interface (making it look and feel very much like Harry Potter)
 - Max wrote the first draft of the final project report
 - Both Max and Shawn revised the final project report
 
## [0.1.0] – 2019-04-27
### Added
 - Both Max and Shawn finished the final project report (`final_report.md` in this repo)
 - Both Max and Shawn finished the final project presentation (`final_presentation.txt` in this repo)
 - Both Max and Shawn finished the final project video: https://www.youtube.com/watch?v=wKQm7nsb_Ok
