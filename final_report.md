# The Magic Elevator: Controlling an Elevator with Wand Spellcasting 



## Idea
Elevators are a curse and a saviour. They enable heavy equipment to be transported across levels and they are often the only means to enable people with mobility impairments to move up and down in a building. However, waiting for them in an awkward silence is anything but exciting. The magic elevator solves this problem: riders become magicians, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator! 

The user experience can best be described with the following figure:

![UserStoryFinal](https://user-images.githubusercontent.com/46902147/56617879-3e11a680-65de-11e9-84a1-052fa412968c.png)

In this final version of the magic elevator, two elevator riders will take the role of magicians. First, the magicians go through a training mode. The UI asks each magician to train her or his own spell to summon the elevator - a gesture and a corresponding voice command is recorded for the two commands of the elevator going up and down. After the training has ended, it is time to put the magicans to the test. Both magicians have to agree on the direction which they want the elevator to go. Accordingly, both magicians cast the spell which they were recording earlier. Only two properly executed spells will call the elevator. 



## Mission Statement
Our mission is to provide a Harry Potter elevator experience. The interaction with the input device (a magic wand) results in a magically activated elevator terminal. As part of our mission the user experience is designed to be seamless and intuitive.


## Encountered Challenges
The encountered challenges can be summarized under legal, hardware and software challenges and are discussed below. These challenges influenced the design of the elevator.

## Receiving Permission:
Since the elevator is university property and part of the infrastructure in ATLAS, the permission to work on the elevator had to be granted for this project. Thanks to the help of professor Ben Shapiro, the competent authorities from facility management approved the magic elevator project. During the project, Program Manager of Facility Management Operations Terry Swindell was updated about the status of the program and conducted field tests at the elevator. 

## Hardware Design:
The requirements of the hardware design resulted directly from the contact with facility management: Any engagement with the elevator must be “hack free”, non-destructive and immediately removable in case of malfunction. The greatest challenge resulting from this restriction turned out to be the physical pressing of the elevator button by an apparatus. 
Whereas it feels counterintuitive to design a machine strong enough to overcome the spring loaded elevator buttons, this was exactly the case in the magic elevator project. After two iterations of solenoids the designers switched over to LEGO Mindstorm motors, which were finally strong enough to activate the elevator. At the same time, the increased power of the pushing mechanism has not only been trying to push the elevator buttons, but to push the whole apparatus off the wall. 3M Dual Lock proved sufficiantly to tuck the apparatus to the elevator terminal. In order to limit shear forces, the design of the LEGO components was made as light as possible. With a smart arangement of gears and belts, the foward and backward rotational moevement of one motor is driving two linear actuators to press the up and down button independantly from each other. Two pictures of the final assembly can be seen below.

![image001](https://user-images.githubusercontent.com/46902147/56619864-453bb300-65e4-11e9-9dc1-1901296acc9d.jpg)

![MagicElevator](https://user-images.githubusercontent.com/46902147/56620131-170aa300-65e5-11e9-92e9-9dce94901ad8.jpg)

## Software Design:
In the magic elevator a number of hardware pieces are communicating with each other (two microbits, one Macbook, Raspberry Pi, LEGO Mindsortms). It was a challenge to decide which software is running on which hardware piece, how communication is established seamlessly and wirelessly. 



Built in Technologies:
Hardware:
Raspberry Pi 3
BrickPi 3
Lego Mindstorm Motor + Miscellaneous
Micro Bits
Elevator Mount
wand

Software:
Wekinator


Description of final UX, model architecture, features

Multiplayer?
Timeline?
Risk to Failure?

Risk to Failure:




