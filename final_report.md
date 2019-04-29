# The Magic Elevator: Controlling an Elevator with Wand Spellcasting 
Maximilian Funck, Shawn Polson

CSCI 5880 Machine Learning for Human-Computer Interaction  
University of Colorado, Boulder

![MagicElevatorTitleImg](https://imagesvc.timeincapp.com/v3/mm/image?url=https%3A%2F%2Ftimedotcom.files.wordpress.com%2F2015%2F11%2Fharry-potter-and-the-deathly-hallows-part-i_10d0b26f.jpg)
_Figure 1: Harry Potter and the Deathly Hallows Part 1 (Warner Bros.)_

## The Idea
Elevators are both a blessing and a curse. They enable heavy equipment to be transported across levels and they are often the only means by which people with mobility impairments can move up and down in a building. However, waiting for them in an awkward silence is anything but exciting. The Magic Elevator solves this problem: riders become witches and wizards, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator! 

This report describes a minimum viable product (MVP) prototype of a system that accomplishes this idea. The prototype was built by Maximilian Funck and Shawn Polson as part of their Machine Learning for Human-Computer Interaction course (CSCI 5880) at CU Boulder. Witches/wizards wield magic wands that are plastic toy Harry Potter wands whose insides were gutted and replaced with a micro:bit that senses X, Y, and Z acceleration. They perform wand motions with voice incantations that together call the elevator either up or down. The witches/wizards come up with and train the motions and incantations themselves through the Magic Elevator's user interface (UI). When spells are correctly cast, a button-pushing mechanism built almost entirely out of LEGO parts (and a Raspberry Pi 3) that is mounted over the elevator buttons summons the elevator in the appropriate direction.

Witches/wizards are free to train a new wand motion or set a new incantation for their spells at any time; Professor Flitwick walks them through it in the UI. When two are present, they must work together to cast agreeing spells to call the elevator in one direction. It's a game; only sufficiently skilled witches/wizards may enter the Magic Elevator! When only one is present, she/he can just call the elevator in single player mode.


## Mission Statement
Our mission is to provide a Harry Potter–like elevator experience with machine learning technology. The interaction with the input device, a wand, results in a magically-activated elevator terminal pressing the buttons to call the elevator. The user experience is designed to be seamless and intuitive, just like magic.


## Description of User Experience
The user experience can best be described with the following cartoon user story:

![UserStoryGithub](https://user-images.githubusercontent.com/46902147/56765798-20227e00-6765-11e9-979d-04eb72f43116.png)  
_Figure 2: User story of the Magic Elevator (illustration)_

In the final version of the Magic Elevator, two elevator riders play the roles of witches/wizards. First, they go through a training mode (the third panel). The UI asks each witch/wizard to train her or his own spell to summon the elevator up or down; the spells are a combination of wand motions and corresponding voice incantations. After the training has ended, it is time to put them to the test. Both witches/wizards have to agree on the direction in which they want the elevator to go. Accordingly, they both cast the spells they recorded earlier (fourth panel). Only two agreeing, properly executed spells will call the elevator (fifth panel). If there is only one witch/wizard present, they can simply call the elevator at will by casting their up or down spell (last panel).

## Description of User Interface
While users of this system mainly interact just with their wands and the elevator, there is a UI on a computer through which they can train their wand motions, change their associated incantations, and see feedback from various system components. The UI is pictured below in Figure 3.

![UserInterface](https://user-images.githubusercontent.com/14846863/56779108-adca9180-6796-11e9-9332-b05396f1e6eb.png)
_Figure 3: Screenshot of user interface and running support scripts_

The main UI in the top right corner is where wand motions are trained and incantations are set. The incantations in the picture are "floors above" and "floors below," meaning if someone wanted to, say, ride the elevator up, they would perform their "up" wand motion and at the same time say "floors above." Clicking either "Change Incantation" button will prompt the user to speak a new incantation for that direction. Clicking either "Train Wand" button will trigger a series of animations during which Professor Flitwick explains to the user that they are about to train a new wand motion before having them perform their new motion ten times in a row. The number ten was empirically chosen because it was the minimum number of examples that consistently resulted in well-performing Wekinator models. 

Wekinator, labeled "Classify wand motions," is free, open-source software for real-time, interactive machine learning. The Magic Elevator system uses a dynamic time warping model in Wekinator to classify up and down wand motions from the wand data shown in the lower left corner. The model analyzes the wand data with a sliding window of roughly one and a half seconds and outputs the degree of match for each class (the three horizontal bars). A wand motion is classified as an up or down spell when the degree of match passes a set threshold, causing an OSC message with the classification to be sent to the Raspberry Pi. The down motion was just classified in the picture.

The wand data are X, Y, and Z acceleration readings from the micro:bit in the wand. The data streams in at approximately 200 readings per second.

The two scripts highlighted in green next to the wand data are the magic behind the incantations. The top script translates spoken words into text via a Python library that leverages Google's speech-to-text API. The script then checks that transcribed text for up or down incantations by comparing it against two files (`up.txt` and `down.txt`) that store the incantations set in the main UI. If an incantation is found in the transcribed text, a corresponding OSC message is sent to the Raspberry Pi. The bottom script activates when either "Change Incantation" button is pressed in the main UI, as it overwrites the phrases in `up.txt` or `down.txt`. This allows for incantations to be changed during runtime without having to restart the transcription script. 

Lastly, the code running on the Raspberry Pi is highlighted in the lower right corner. The Raspberry Pi is equipped with Dexter Industries' BrickPi3 shield and runs a modified Raspbian image provided by Dexter Industries. This setup allows direct control of the LEGO motor that presses the elevator buttons. The Raspberry Pi desktop is visible because it is streamed over Wi-Fi to the main computer through a program called VNC Viewer. The script on the right turns the motor clockwise or counterclockwise to predetermined positions in order to extend the linear actuators that physically press the elevator buttons. Commands to turn the motor are only sent from the script on the left when wand motions are correctly performed with incantations. This means that if a user, say, does the wand motion for up but does not also speak the proper incantation, nothing will happen. The same goes for when two users are present; they must both correctly perform agreeing spells for the elevator to be called.


## Features
Listed explicitly, the final features of this project are the abilities to:
 - Call an elevator up or down with magic spells consisting of wand motions and voice incantations
 - Change the wand motions during runtime
 - Change the voice incantations during runtime
 - Coordinate with fellow witches/wizards to magically call the elevator in an agreed-upon direction

## Challenges Encountered 
The encountered challenges can be summarized as legal, hardware, and software challenges and are discussed below. These challenges influenced the design of the Magic Elevator system.

### Receiving Permission:
Since the elevator is university property and part of the infrastructure in ATLAS, permission to work on the elevator had to be granted for this project. Thanks to the help of professor Ben Shapiro, the relevant authorities from facility management approved the Magic Elevator project. During the project, Program Manager of Facility Management Operations Terry Swindell was updated about the status of the program and field tests conducted at the elevator. 

### Hardware Design:
The requirements of the hardware design came directly from contact with facility management: Any engagement with the elevator had to be “hack free”, non-destructive, and immediately removable in case of malfunction. The greatest challenge resulting from these restrictions turned out to be physically pressing the elevator buttons with an apparatus (the only remaining option to call the elevator). The elevator buttons are spring loaded—a machine to activate the elevator must 1) be strong enough to overcome the spring force of the buttons and 2) be appropriately attached to the elevator panel in order to not push itself off the wall.  
In the first iteration, a 3D-printed case held a Raspberry Pi and two electric solenoids. This first iteration can be seen in Figure 4.

![SolenoidIteration](https://user-images.githubusercontent.com/46902147/56854968-59d9bd00-68fc-11e9-9a6c-6a34c0a055ad.png)
_Figure 4: First iteration of the Magic Elevator hardware_

After two failed iterations of solenoids which were too weak to press the buttons, we switched to a LEGO Mindstorms motor that was finally strong enough to push the buttons. At the same time, the increased power of the pushing mechanism was trying to push the whole apparatus off the wall before pushing the buttons. 3M Dual Lock proved sufficient to stick the apparatus to the elevator terminal. In order to limit shear forces, the design of the LEGO components was made as light as possible. With a smart arrangement of gears and belts, the forward and backward rotational movement of one motor is now driving two linear actuators to press the up and down buttons independently. A picture of the final assembly is shown below.

![HardwareDetail](https://user-images.githubusercontent.com/46902147/56911324-ec4b9f00-6a69-11e9-9782-040f9df6feaf.png)
_Figure 5: Magic Elevator hardware mounted to the elevator terminal_

### Software Design:
A number of hardware pieces are communicating with each other (two micro:bits per wand, a MacBook, a Raspberry Pi, and a LEGO Mindstorms motor). It was a challenge to decide which software is running on which hardware piece, and how communication is established seamlessly and wirelessly between them. In the end, OSC messages over Wi-Fi facilitate the communication. It was also challenging to 1) tune the parameters for dynamic time warping models for optimal gesture classification, 2) incorporate voice incantations along with the wand gestures, and 3) consistently identify incantations in noisy environments. 

Dynamic time warping models have parameters for maximum downsampling length of examples, minimum length used for matches, and two others called "match width" and "match hop size." The first two were both set to 30 because it was empirically determined to be the largest number before the MacBook would run out of memory and become jittery. And keeping the minimum length used for matches the same as the maximum downsampling length prevented the beginnings of one wand gesture from being falsely classified as the other. 

Incorporating incantations with wand gestures forced the addition of three new scripts to the Magic Elevator system. They are the scripts labeled "transcribe incantations," "change incantations," and "receive spells" in Figure 3. They had to be added to interpret voices, to change incantations during runtime, and to check for matches between gestures and incantations before activating the motor, respectively.

Identifying incantations relies on Google's speech-to-text API. Anyone who has dictated to a virtual assistant like Google Assistant or Siri is likely aware of how finicky those transcriptions can be. Especially in noisy environments, this script is prone to problems like interpreting "floors above" as "where's the love." There is no real workaround to this problem. It can be improved by using headphones that reduce ambient noise, but that breaks the illusion of magic and so is undesirable. 


## Built-in Technologies
The technologies used in this project are listed below.

### Hardware:
- Raspberry Pi 3
- BrickPi 3
- LEGO Mindstorms Motor + Miscellaneous LEGOs
- micro:bits
- Elevator Mount
- Harry Potter Wands
- MacBook (with its built-in microphone)

### Software (all open source):

- Wekinator

#### Languages:
- Processing
- Python 3
- micro:bit .HEX code

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
- BrickPi3

The Raspberry Pi and BrickPi were combined with the LEGO hardware and the elevator mount to create the button-pushing apparatus (Figure 5). The micro:bits contain accelerometers that provide the data for wand gestures and were combined with store-bought Harry Potter wands (really, just their plastic casings) to create the magic wands. The MacBook runs all the software not on the Raspberry Pi (including Wekinator which does the dynamic time warping) and its microphone (or, optionally, the microphone of headphones plugged into the MacBook) listens for incantations. micro:bit .HEX code is required for the micro:bits, and both Processing and Python had to be used because even though Processing proved to be the most useful language for the project overall (e.g., the main UI is written in it), certain aspects like voice recognition and controlling the LEGO motor were only possible in Python. 

## System Architecture

The system architecture is depicted in the following scheme:

![SystemArchitecture](https://user-images.githubusercontent.com/46902147/56823440-16eeeb00-6811-11e9-8fc0-9a917a242d1d.png)
_Figure 6: System architecture_

Two user interactions are the inputs for the Magic Elevator system: a wand gesture and a voice command. The wand gesture consists of acceleration data in the X, Y, and Z axes from micro:bits sitting inside the wands. The acceleration data is sent wirelessly to another micro:bit plugged into the USB port of the MacBook. The Python script `wand_to_osc.py` packs the acceleration data into OSC messages which are then sent to Wekinator. Wekinator is set up with the model type "dynamic time warping" (DTW) and listens for three inputs (X, Y, Z), outputting 3 gesture classifications (up, down, and no gesture). The training and run mode of Wekinator are controlled via OSC messages coming from the UI. The OSC message for an elevator up or down signal is sent to the Raspberry Pi only if the trained gesture is performed with sufficient accuracy. 

On a second input channel, the voice of the witch/wizard is recorded. With the help of Google's speech-to-text software, the spoken words are translated into text with the `incantations.py` script. The transcribed speech is constantly compared against the incantations stored in two text documents (`up.txt` and `down.txt`). By default, the text documents contain the phrases "floors above" and "floors below." However, they can be overwritten during runtime in the training mode. Once a match is detected, the corresponding OSC message for up or down is sent to the Raspberry Pi. 

On the Raspberry Pi, the OSC messages generated through the wand gestures and voice transcriptions are brought together in the `callelevator.pde` program. Only if both messages indicate the same elevator direction does that program send the motor activation signal through the BrickPi3 shield. The BrickPi3 is attached to the Raspberry Pi through the GPIO (General-Purpose Input/Output) pins and is powered by a 12V battery pack. The motor activation signal triggers the electric motor to turn approximately 4.2 rotations in either direction (depending on the up or down signal). Through gears and belts, the rotary motion is translated to a linear motion which eventually presses either elevator button, summoning the elevator.

## Risks to Failure
In the project proposal, it was anticipated that a lack of permission to work on the elevator would bring the whole project to a halt. Luckily, this did not happen. Early on in the project, the preliminarily chosen solenoid hardware did not deliver the required force, even in the second iteration. Without working hardware nor the ability to replace the spring-loaded buttons on the elevator, the project was at risk of failing. With the help of professor Shapiro and PhD student Kailey Shara, the solenoids were replaced by one LEGO Mindstorms motor. In combination with a laser-cut acrylic panel and 3M dual lock tape, an apparatus was built that has enough force to push elevator buttons while sticking to the elevator terminal as required. Unfortunately, iterating through hardware took longer than anticipated, so some features had to be dropped in order to save time. This is discussed in the following section.

## Dropped Features
- Instead of three elevator riders, only two are interacting with this version of the Magic Elevator. This saved time that would have otherwise been spent developing a voting mechanism and a more sophisticated, probably confusing, training mode
- The formerly-intended interaction inside the elevator was dropped for simplicity reasons. The system only operates outside the elevator. Pressing up to four buttons inside the elevator would have required more motors and/or gears and a larger LEGO platform. It would have expanded the user experience, but because it was dropped, time was saved and no new machine learning element had to be added. 

## Ethical Considerations
The Magic Elevator project came with a manageable amount of ethical questions. First of all, the elevator could not be damaged nor physically hacked in any way to ensure its continued safety. Harming an elevator's operations is a federal offense, so all applicable laws had to be carefully followed. We also had to ensure that users were able to overrule the system at any given time by physically pressing the buttons inside and outside the elevator. Additions to the elevator could not in any way reduce the usability or accessibility of the elevator itself. To accomplish this, the elevator is controlled only by pressing its buttons like normal, except with mounted hardware instead of human fingers, of course. The first iteration of the hardware included a 3D-printed casing that had outward-facing buttons that allowed fingers to manually press the buttons via the solenoids. But that version had to be scrapped in favor of the new, working LEGO hardware. That hardware mounted at the elevator lacks pushable buttons, but it can easily be removed by the users, returning the elevator to its original state.

## Conclusions
Within a timespan of seven weeks, a fully functional prototype of the Magic Elevator was developed. Witches/wizards can call an elevator with their magic spells. Challenges related to the hardware, software, and legal aspects of the projects demanded an iterative design approach but were eventually overcome. During the project, our team learned hard skills such as programming on a Raspberry Pi/BrickPi, working with speech recognition applications, designing appealing user interfaces, and establishing communication channels between different pieces of hardware. The use of rapid prototyping, such as 3D-printing and laser cutting, facilitated the iterative design process and lessened a steep learning curve. 

In addition to the mentioned hard skills, this project was as a great showcase of soft skills, an example of how interdisciplinary teams can succeed when sharing knowledge. The Magic Elevator was born of the well-functioning collaboration between a computer scientists and a mechanical engineer. Contributing to the project, either from the software or the hardware side, enabled mutual learning in many instances.  

Future improvements of the Magic Elevator could include the expansion of the user experience. How do witches/wizards choose their wands? How can witches/wizards select floors? How can more than two witches/wizards interact with the elevator? What happens if they want to go to different floors or in different directions? The elevator could decide which floor to visit based on who among a group casts their spell most accurately, and the system could be expanded to allow choosing specific floors with spells. That implementation remains to be seen. The voice recognition for incantations is another area that could be improved in the future. This project used Google's speech-to-text API out of the box which brought caveats discussed earlier. A new, unique voice recognition component could improve the overall performance of the system, including the ability to say non-English (e.g., Latin) incantations. And of course, the dynamic time warping model could always be further tweaked for better performance or the system could be given greater computing resources to increase the model's capabilities.

Last but not least, we would like to thank our professor, Ben Shapiro, PhD student Kailey Shara, and Dexter Industries for the continued support throughout the project.


## Bibliography
 - http://www.wekinator.org/
 - http://www.wekinator.org/detailed-instructions/#Controlling_Wekinator_via_OSC_messages
 - https://github.com/fiebrink1/wekinator
 - https://kadenze.com/courses/machine-learning-for-musicians-and-artists-v/sessions/working-with-time
 - https://makecode.microbit.org/
 - https://realpython.com/python-speech-recognition/
 - https://pypi.org/project/python-osc/
 - https://iamkelv.in/blog/2017/06/zerotier.html
 - https://learn.sparkfun.com/tutorials/how-to-use-remote-desktop-on-the-raspberry-pi-with-vnc/all
 - https://www.dexterindustries.com/brickpi3-tutorials-documentation/
 - https://www.dexterindustries.com/howto/install-raspbian-for-robots-image-on-an-sd-card/
 - https://www.lego.com/en-us/mindstorms/learn-to-program
 - https://github.com/DexterInd/BrickPi3
 - https://processing.org/examples/setupdraw.html
 - https://processing.org/examples/button.html
 
