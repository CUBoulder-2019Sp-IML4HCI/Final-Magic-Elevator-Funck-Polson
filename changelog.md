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
