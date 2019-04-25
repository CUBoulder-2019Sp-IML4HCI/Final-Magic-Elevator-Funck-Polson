# The Magic Elevator: Controlling an Elevator with Wand Spellcasting 
Max Funck, Shawn Polson

![MagicElevatorTitleImg](https://imagesvc.timeincapp.com/v3/mm/image?url=https%3A%2F%2Ftimedotcom.files.wordpress.com%2F2015%2F11%2Fharry-potter-and-the-deathly-hallows-part-i_10d0b26f.jpg)
_Harry Potter and the Deathly Hallows Part 1 (Warner Bros.)_

## The Idea
Elevators are both a blessing and a curse. They enable heavy equipment to be transported across levels and they are often the only means by which people with mobility impairments can move up and down in a building, but waiting for them in an awkward silence is anything but exciting. The Magic Elevator solves this problem: riders become witches/wizards, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator! 

This report describes a minimum viable product (MVP) prototype of a system that accomplishes that idea. The prototype was built by Max Funck and Shawn Polson as part of their Machine Learning for Human-Computer Interaction course (CSCI/ATLS 4889/5880 at CU Boulder). Witches/wizards wield magic wands that are plastic toy Harry Potter wands whose insides were gutted and replaced with a Micro:bit that senses X, Y, and Z acceleration. They perform wand motions with voice incantations that together call the elevator either up or down. They come up with and train the motions and incantations themselves via the Magic Elevator user interface (UI). When spells are correctly cast, a button-pushing mechanism built almost entirely out of LEGO parts that is mounted over the elevator buttons summons the elevator in the appropriate direction.

Witches/wizards are free to train a new wand motion or set a new incantation for their spells at any time; Professor Flitwick walks them through it in the UI. When two are present, they must work together to cast agreeing spells to call the elevator in one direction. It's a game; only sufficiently skilled witches/wizards may enter the Magic Elevator! When only one is present, they can simply call the elevator at will.


## Mission Statement
Our mission is to provide a Harry Potter–like elevator experience with technology. The interaction with the input device, a wand, results in a magically-activated elevator terminal pressing the buttons to call the elevator. The user experience is designed to be seamless and intuitive—magic.


## Description of User Experience
The user experience can best be described with the following cartoon figure:

![UserStoryGithub](https://user-images.githubusercontent.com/46902147/56765798-20227e00-6765-11e9-979d-04eb72f43116.png)


In the final version of the Magic Elevator, two elevator riders can take the role of witch/wizard. First, they go through a training mode (the third panel). The UI asks each witch/wizard to train her or his own spell to summon the elevator up or down; the spells are a combination of wand motions and corresponding voice incantations. After the training has ended, it is time to put them to the test. Both witches/wizards have to agree on the direction in which they want the elevator to go. Accordingly, they both cast the spells they recordied earlier (fourth panel). Only two agreeing, properly executed spells will call the elevator (fifth panel). If there is only one witch/wizard present, they can simply call the elevator at will by casting their up or down spell (last panel).

## Description of User Interface
While users of this system mainly interact just with their wands and the elevator, there is a UI on a computer through which they can train their wand motions, change their associated incantations, and see feedback from various system components. The UI is pictured below.

![UserInterface](https://user-images.githubusercontent.com/14846863/56772668-3128ba80-6778-11e9-8ff1-6ec7387deacc.png)
**_TODO: crop/label pic, then describe it_**


## Features
Listed explicitly, the final features of this project are the abilities to:
 - Call an elevator up or down with magic spells consisting of wand motions and voice incantations
 - Change the wand motions during runtime
 - Change the voice incantations during runtime
 - Coordinate with fellow witches/wizards to magically call the elevator in an agreed-upon direction

## Challenges Encountered 
The encountered challenges can be summarized as legal, hardware, and software challenges and are discussed below. These challenges influenced the design of the magic elevator system.

### Receiving Permission:
Since the elevator is university property and part of the infrastructure in ATLAS, permission to work on the elevator had to be granted for this project. Thanks to the help of professor Ben Shapiro, the relevant authorities from facility management approved the magic elevator project. During the project, Program Manager of Facility Management Operations Terry Swindell was updated about the status of the program and field tests conducted at the elevator. 

### Hardware Design:
The requirements of the hardware design came directly from contact with facility management: Any engagement with the elevator had to be “hack free”, non-destructive, and immediately removable in case of malfunction. The greatest challenge resulting from these restrictions turned out to be physically pressing the elevator buttons with an apparatus (our only remaining option to call the elevator). 
Whereas it feels counterintuitive to design a machine strong enough to overcome the spring loaded elevator buttons, this was exactly the case in the Magic Elevator project. After two failed iterations of solenoids which were too weak to press the buttons, the designers switched to a LEGO Mindstorms motor that was finally strong enough to push the elevator buttons. At the same time, however, the increased power of the pushing mechanism was trying to push not only the elevator buttons, but also the whole apparatus off the wall. 3M Dual Lock proved sufficiant to stick the apparatus to the elevator terminal. In order to limit shear forces, the design of the LEGO components was made as light as possible. With a smart arrangement of gears and belts, the foward and backward rotational movement of one motor is driving two linear actuators to press the up and down buttons independantly. A picture of the final assembly is shown below.


![MagicElevatorHardware](https://user-images.githubusercontent.com/46902147/56620131-170aa300-65e5-11e9-92e9-9dce94901ad8.jpg)
**_TODO: update picture with everything properly connected_**

### Software Design:
A number of hardware pieces are communicating with each other (two microbits per wand, a Macbook, a Raspberry Pi, a LEGO Mindstorms motor). It was a challenge to decide which software is running on which hardware piece, and how communication is established seamlessly and wirelessly between them. It was also challenging to 1) tune the parameters for Dynamic Time Warping models for optimal gesture classification (**_TODO: explain decision to downsample to 30, say more for 2 and 3)_**), 2) incorporate voice incantations along with the wand gestures (Google's voice-to-text API is used in the final product), and 3) to consistently identify voice incantations in noisy environments. A picture of the final software arrangement is shown below.

![MagicElevatorSoftware](https://user-images.githubusercontent.com/14846863/56691152-72e43300-669c-11e9-9324-7e4fd87d5203.png)
**_TODO: update picture with everything running_**



## Built-in Technologies
The technologies used in this project are listed below.

### Hardware:
- Raspberry Pi 3
- BrickPi 3
- LEGO Mindstorms Motor + Miscellaneous LEGOs
- Micro:bits
- Elevator Mount
- Harry Potter Wands
- MacBook (with its built-in microphone)

### Software (all open source):

- Wekinator

#### Languages:
- Processing
- Python 3
- Micro:bit .HEX code

#### Processing Libraries:
- oscP5
- netP5
- processing.io

#### Python Libraries:
- serial
- pythonosc
- speech_recognition
- argparse
- sys
- time
- brickpi3

The Raspberry Pi and BrickPi were combined with the LEGO hardware and the elevator mount to create the button-pushing apparatus, pictured earlier in this document. The Micro:bits contain accelerometers that provide the data for wand gestures and were combined with store-bought Harry Potter wands (really, just their plastic casings) to create the magic wands. The MacBook runs all the software not on the Raspberry Pi (including Wekinator which does the Dynamic Time Warping) and its microphone (or, optionally, the microphone of headphones plugged into the MacBook) listens for voice incantations. Micro:bit .HEX code is required for the Micro:bits, and both Processing and Python had to be used because while Processing proved to be the most useful language for the project overall, certain aspects like voice recognition and controlling the LEGO motor were only possible in Python. 

## Model Architecture

The model architecture is depicted in the following scheme:

![MagicElevatorLogic](https://user-images.githubusercontent.com/46902147/56692799-387c9500-66a0-11e9-8687-307bd76d8758.png)

Two user interactions are the inputs for the magic elevator system: a wand gesture and a voice command. The wand gesture consists of acceleration data in the x, y, and z axes from Micro:bits sitting inside the wands. The acceleration data is sent wirelessly to another Micro:bit plugged into the USB port of the MacBook. The Python script `wand_to_osc.py` packs the acceleration data into OSC messages which are then sent to Wekinator. Wekinator is set up with the model type "Dynamic Time Warping" (DTW) and listens for three inputs (x, y, z), outputting 3 gesture classifications (up, down, and no gesture). The training and run mode of Wekinator are controlled via OSC messages coming from the UI. The OSC message for an elevator up or down signal is sent to the Raspberry Pi only if the trained gesture is performed with sufficient accuracy. 

On a second input channel, the voice of the witches/wizards are recorded. With the help of Google's speech-to-text software, the spoken words are translated into text with the `incantations.py` script. The transcribed speech is constantly compared against the incantations stored in two text documents (`up.txt` and `down.txt`). By default, the txt documents contain the phrases "floors above" and "floors below". However, they can be overwritten during runtime in the training mode. Once a match is detected, the corresponding OSC message for up or down is sent to the Raspberry Pi. 

On the Raspberry Pi, the OSC messages generated through the wand gesutures and voice transcriptions are brought together in the `callelevator.pde` program. Only if both messages indicate the same elevator direction does that program send the motor activation signal through the BrickPi3 shield. The BrickPi3 is attached to the Raspberry Pi through the GPIO (General-Purpose Input/Output) pins and is powered by a 12V battery pack. The motor activation signal triggers the electric motor to turn approximately 4.2 rotations in either direction (depending on the up or down signal). Through gears and belts the rotary motion is translated to a linear motion which eventually presses either elevator button, summoning the elevator.

## Risks to Failure
In the project proposal, it was anticipated that a lack of permission to work on the elevator would bring the whole project to a halt. Luckily, this was not the case. Early on in the project, the preliminarily chosen solenoid hardware did not deliver the required force, even in the second iteration. Without working hardware nor the ability to replace the spring-loaded buttons on the elevator, the project was at risk of failing. With the help of professor Shapiro and PhD student Kailey Shara, the solenoids were replaced by one LEGO Mindstorms motor. In combination with a laser-cut acrylic panel and 3M dual lock tape, an apparatus was built that has enough force to push elevator buttons while sticking to the elevator terminal as required. Unfortunately, iterating through hardware took longer than anticipated, so some features had to be dropped in order to save time. This is discussed in the following section.

## Dropped Features
- Instead of three elevator riders, only two are interacting with this version of the magic elevator. This saved time that would have otherwise been spent developing a voting mechanism and a more sophisticated, probably confusing, training mode
- The interaction inside the elevator has been dropped for simplicity reasons. Pressing up to four buttons inside the elevator would have required more motors and/or gears and a larger LEGO platform. It would have expanded the user experience, but because it was dropped, time was saved and no new machine learning element had to be added. 

## Ethical Considerations
The Magic Elevator projet came with a manageable amount of ethical questions. First of all, the elevator could not be damaged or physically hacked in any way to ensure its continued safety. Harming an elevator's operations is a federal offense, so all applicable laws had to be carefully followed. The designers also had to ensure that at any given time, users were able to overrule the system by physically pressing the buttons inside and outside the elevator. Additions to the elevator could not in any way reduce the usability or accessibility of the elevator. To accomplish this, the elevator is controlled only by pressing its buttons like normal, except with mounted hardware instead of human fingers, of course. The first iteration of the hardware included a 3D-printed casing that had outward-facing buttons that allowed fingers to manually press the buttons via the solenoids. But that version had to be scrapped in favor of the new, working LEGO hardware. That hardware mounted at the elevator lacks pushable buttons, but it can easily be removed by the users, returning the elevator to its original state.

## Conclusions
**_TODO: We learned xyz. It worked (this) well. Future improvements could be xyz._**

## Bibliography
**_TODO_**





