# The Magic Elevator: Controlling an Elevator with Wand Spellcasting 

![MagicElevatorTitleImg](https://imagesvc.timeincapp.com/v3/mm/image?url=https%3A%2F%2Ftimedotcom.files.wordpress.com%2F2015%2F11%2Fharry-potter-and-the-deathly-hallows-part-i_10d0b26f.jpg)
Harry Potter and the Deathly Hallows Part 1 (Warner Bros.)

## Idea
Elevators are a curse and a saviour. They enable heavy equipment to be transported across levels and they are often the only means to enable people with mobility impairments to move up and down in a building. However, waiting for them in an awkward silence is anything but exciting. The magic elevator solves this problem: riders become magicians, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator! 


## Description of final user experience
The user experience can best be described with the following figure:

![UserStoryFinal](https://user-images.githubusercontent.com/46902147/56617879-3e11a680-65de-11e9-84a1-052fa412968c.png)

In this final version of the magic elevator, two elevator riders will take the role of magicians. First, the magicians go through a training mode. The UI asks each magician to train her or his own spell to summon the elevator - a gesture and a corresponding voice command is recorded for the two commands of the elevator going up and down. After the training has ended, it is time to put the magicans to the test. Both magicians have to agree on the direction which they want the elevator to go. Accordingly, both magicians cast the spell which they were recording earlier. Only two properly executed spells will call the elevator. 



## Mission Statement
Our mission is to provide a Harry Potter elevator experience. The interaction with the input device (a magic wand) results in a magically activated elevator terminal. As part of our mission the user experience is designed to be seamless and intuitive.


## Encountered Challenges
The encountered challenges can be summarized under legal, hardware and software challenges and are discussed below. These challenges influenced the design of the elevator.

### Receiving Permission:
Since the elevator is university property and part of the infrastructure in ATLAS, the permission to work on the elevator had to be granted for this project. Thanks to the help of professor Ben Shapiro, the competent authorities from facility management approved the magic elevator project. During the project, Program Manager of Facility Management Operations Terry Swindell was updated about the status of the program and conducted field tests at the elevator. 

### Hardware Design:
The requirements of the hardware design resulted directly from the contact with facility management: Any engagement with the elevator must be “hack free”, non-destructive and immediately removable in case of malfunction. The greatest challenge resulting from this restriction turned out to be the physical pressing of the elevator button by an apparatus. 
Whereas it feels counterintuitive to design a machine strong enough to overcome the spring loaded elevator buttons, this was exactly the case in the magic elevator project. After two iterations of solenoids the designers switched over to LEGO Mindstorm motors, which were finally strong enough to activate the elevator. At the same time, the increased power of the pushing mechanism has not only been trying to push the elevator buttons, but to push the whole apparatus off the wall. 3M Dual Lock proved sufficiantly to tuck the apparatus to the elevator terminal. In order to limit shear forces, the design of the LEGO components was made as light as possible. With a smart arangement of gears and belts, the foward and backward rotational moevement of one motor is driving two linear actuators to press the up and down button independantly from each other. The picture of the final assembly can be seen below.


![MagicElevator](https://user-images.githubusercontent.com/46902147/56620131-170aa300-65e5-11e9-92e9-9dce94901ad8.jpg)

### Software Design:
In the magic elevator a number of hardware pieces are communicating with each other (two microbits, one Macbook, Raspberry Pi, LEGO Mindsortms). It was a challenge to decide which software is running on which hardware piece, how communication is established seamlessly and wirelessly. 



## Built in Technologies:
### Hardware:
- Raspberry Pi 3
- BrickPi 3
- Lego Mindstorm Motor + Miscellaneous
- Micro Bits
- Elevator Mount
- Harry Potter Wand 

### Software Languages:
- Processing
- Python 3
- Microbit.hex code

### Processing Libraries
- oscP5
- netP5
- processing.io

### Python Libraries:
- serial
- pythonosc
- argparse
- sys
- time
- brickpi3

## Model Architecture:

The model architecture is depicted in the following scheme:

![MagicElevatorLogic](https://user-images.githubusercontent.com/46902147/56620778-5934e400-65e7-11e9-9690-3f9e9c04515c.png)

In total, two user interactions are the inputs for the magic elevator - a wand gesture and a voice command. The wand gesture consists of acceleration data in x,y and z axis which is recorded by a microbit sitting inside the wand. The acceleration data is sent wirelessly to a second microbit, which is plugged into the USB port of the Macbook. The python program wand_to_osc.py packs the acceleration data into OSC packages which are being sent to Wekinator. Wekinator is set up with the model type dynamic time wraping (DTW) and listens for three inputs, outputting 3 gesture types (up, down and no gesture). The training and run mode of wekinator are controlled via OSC messages coming from the user interface. Only if the trained gesture is repeated with a sufficient accuracy, the OSC message for an elevator up or down signal is sent to the Raspberry Pi. On a second input channel, the voice of the magicians are recorded. With the help of Google's speech to text software, the spoken words are translated into text bricks with the incontation.py script. The recorded speech is constantly compared to two .txt documents. In default mode, the txt documents contain the words "floors below" and "floors above". However, they may be overwritten in the training mode. Once a match is detected, the corresponding OSC message is sent to the Raspberry Pi. On the Raspberry Pi, the OSC messages generated trough the Wand Gesuture and the Voice Recognition are brought together in the start_callelevator.py script. Only if both messages indicate the same elevator direction, the RaspberryPi sends the motor activation signal through the BrickPi3 shield. The BrickPi3 is attached to the RaspberryPi through the GPIO (general-purpose input/output) pins and is powered by a 12V battery pack. The motor activation signal triggers the electric motor to turn 4.2 rotations in either direction (depending on the up or down signal). Through gears and belts the rotary motion is translated to a linear motion which eventually presses either elevator button.

## Risk to Failure:
In the project proposal it was anticipated that a not granted allowance to work on the elevator would bring the whole project to a halt. Luckily, this was not the case. During the runtime of the project, the preliminary chosen solenoid hardware did not deliver the required force, even in the second iteration. Without working hardware nor the ability to replace the springloaded buttons on the elevator, the project was at risk to failure. With the help of professor Shapiro and PhD student Kailey Shara the solenoids were replaced by one LEGO Mindstorm motor. In combination with a laser-cut panel and 3M dual lock tape an apparatus could be built that has enough force to push elevator buttons while sticking to the elevator terminal as required. Unfortunately, the iterations through hardware took longer than anticipated leading to the dropping of some features. This will be discussed in the following section

## Dropped Features:
- Instead of three magicians (elevator riders), only two are interacting with this version of the magic elevator. This saves the time to develop a voting mechanism and a more sophisticated, probably confusing training mode
- The interaction inside the elevator has been dropped for simplicity reasons. Pressing up to four buttons inside the elevator would have required more motors and/or gears and a larger LEGO platform. Whereas it would have expanded the user experience, no new machine learning element would have been added. 




