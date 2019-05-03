# The Magic Elevator

## Team Members
 - Max Funck
 - Shawn Polson
 
## Video Demo
[![Magic Elevator Demo Video](https://user-images.githubusercontent.com/14846863/57108134-18c41d00-6cef-11e9-9650-c58e91006778.jpg)](https://youtu.be/PoPb2fAdgJ8)
https://youtu.be/PoPb2fAdgJ8


## The Idea
Elevators are both a blessing and a curse. They enable heavy equipment to be transported across levels, and they are often the only means by which people with mobility impairments can move up and down in a building. However, waiting for them in an awkward silence is anything but exciting. The Magic Elevator solves this problem: riders become witches and wizards, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator!

This report describes a minimum viable product (MVP) prototype of a system that accomplishes this idea. The prototype was built by Maximilian Funck and Shawn Polson as part of their Machine Learning for Human-Computer Interaction course (CSCI 5880) at CU Boulder. Witches/wizards wield magic wands that are plastic toy Harry Potter wands whose insides were gutted and replaced with a micro:bit that senses X, Y, and Z acceleration. They perform wand motions with voice incantations that together call the elevator either up or down. The witches/wizards come up with and train the motions and incantations themselves through the Magic Elevator's user interface (UI). When spells are cast correctly, a button-pushing mechanism built almost entirely out of LEGO parts (and a Raspberry Pi 3), which is mounted over the elevator buttons, summons the elevator in the appropriate direction.

Witches/wizards are free to train a new wand motion or set a new incantation for their spells at any time; Professor Flitwick walks them through it in the UI. When two users are present, they must work together to cast agreeing spells to call the elevator in one direction. It's a game; only sufficiently skilled witches/wizards may enter the Magic Elevator! When only one is present, she or he can just call the elevator in single-player mode.

## Mission Statement
Our mission is to provide a Harry Potter–like elevator experience with machine learning technology. The interaction with the input device, a wand, results in a magically activated elevator terminal pressing the buttons to call the elevator. The user experience is designed to be seamless and intuitive, just like magic.

## User Experience
![UserStoryGithub](https://user-images.githubusercontent.com/46902147/56765798-20227e00-6765-11e9-979d-04eb72f43116.png)  

## Building the Project
This repo contains all the software needed to recreate the Magic Elevator. The hardware, wands and the mechanical button pusher, were custom-built and recreating them isn't trivial. But here we include details for building all aspects of our system. 

### Building the Software
![UserInterface](https://user-images.githubusercontent.com/14846863/56779108-adca9180-6796-11e9-9332-b05396f1e6eb.png)

All the software is shown in the picture above. Here's how to use/build each component.
#### Main UI
The program labeled "Main UI" in the picture above is [`Flitwick_Spell_Training/Flitwick_Spell_Training.pde`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/Flitwick_Spell_Training.pde) in this repo. It's a self-contained Processing program that will run once you have installed the libraries it imports. It relies on three system fonts that we put in [`Flitwick_Spell_Training/data/`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/Flitwick_Spell_Training/data): `4PrivetDrive-Regular.otf`, `HARRP___.TTF`, and `LumosLatino.ttf`.

#### Wand data
The script labeled "Wand data" is acceleration output from the wand micro:bits. Three code files are needed to stream this data: [`wand/mbit/microbit-sendXYZ*.hex`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/wand/mbit), [`wand/mbit/microbit-receiveXYZ*.hex`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/wand/mbit), and [`wand/py/wand_to_osc.py`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/wand/py/wand_to_osc.py). The data streams from the micro:bit in a wand to a micro:bit plugged into the computer, then to `wand_to_osc.py` which prints and sends the data. Building the wand itself is covered in the **Building the Hardware** section. To make the software work, plug the wand micro:bit into your computer and drag either `microbit-sendXYZ.hex` or `microbit-sendXYZ2.hex` into the MICROBIT directory that appears. There are two versions of this send code, and of the receive code for that matter, to support using two wands at once; the only difference between the files is that they use different radio channels. After you drag the send code into the wand micro:bit, plug in a second microbit and drag either `microbit-receiveXYZ.hex` or `microbit-receiveXYZ2.hex`, depending on which send version you use in the wand, into the MICROBIT directory that appears. You are now streaming acceleration data from the wand to your computer. The last step is to run `wand_to_osc.py` after changing line 10 match the serial port your computer generates for the receiving micro:bit. You will then see the data streaming like in the picture.

#### Classify wand motions
The program labeled "Classify wand motions" is [Wekinator](http://www.wekinator.org/), free, open-source software for real-time, interactive machine learning. It uses a dynamic time warping model to classify wand motions from the wand data. You could learn about Wekinator from the documentation on their website and configure your own model, but for convenience, we've uploaded the model we used in [`WandToMotorModel/`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/WandToMotorModel). Download Wekinator, open it, click `File -> Open project...` and select the [`WandToMotorModel.wekproj`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/WandToMotorModel/WandToMotorModel.wekproj) file. This model will not have any training examples for wand motions, so you will want to train your own motions for calling the elevator up and down by clicking the appropriate buttons in the main UI. `wand_to_osc.py` sends the wand's acceleration data to Wekinator via OSC messages sent to localhost on port 8999. Make sure Wekinator is listening on that port (our uploaded model will be). Wekinator sends its classifications to the Raspberry Pi controlling the button pusher also via OSC messages, sent to *an IP address* at port 12000. You will have to change the IP address used for Wekinator's output to match the IP of your Raspberry Pi.

#### Transcribe incantations
This script is [`Flitwick_Spell_Training/incantations.py`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/incantations.py) in this repo. It uses Google's speech-to-text API, via the Python library `speech_recognition`, to transcribe your incantations. Install the libraries it imports, then run it and watch it recognize phrases you speak. There are two caveats to using this script: 1) It must remain inside the `Flitwick_Spell_Training` directory because it reads incantations you set in the main UI from two files: [`data/up.txt`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/data/up.txt) and [`data/down.txt`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/data/down.txt). 2) You must change the IP address on line 5 of this script to match the IP address of your Raspberry Pi, so that the OSC messages it sends actually get delivered. 

#### Change incantations
This script is [`/Flitwick_Spell_Training/change_incantations_server.py`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/change_incantations_server.py) in this repo. It must be running before you press either "Change Incantation" button in the main UI. This is because the first phrase it hears you speak after clicking one of those buttons gets written to either `up.txt` or `down.txt`—this is how we support changing incantations during runtime.

#### Receive spells
This program is [`pi/callelevator/callelevator.pde`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/pi/callelevator/callelevator.pde) in this repo. OSC messages from wand motions and voice incantations are received by this program. It must be running on your Raspberry Pi for the button pusher to work. 

#### LEGO motor control
This script is either [`pi/motor_osc_server.py`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/pi) or [`pi/motor_osc_server_2.py`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/pi) in this repo. Running the former will put the Magic Elevator system in single-player mode, while the latter will put it in two-player mode. The difference is that in two-player mode, only two spells cast properly in agreement will call the elevator. When either script is running, it receives OSC messages from `callelevator.pde` that tell it to move the LEGO motor to press either the up or down elevator button.

### Building the Hardware

The hardware of the Magic Elevator consists of an input device—a magic wand—and an output device—the mechanical button pusher. The magic wand uses a [toy wand](https://www.amazon.com/Harry-Potter-Potters-Wizard-Training/dp/B01N29ENXW/ref=sr_1_3?keywords=harry+potter+wand&qid=1556837733&s=gateway&sr=8-3) as a case. The interior is taken out and replaced by a [micro:bit](https://www.amazon.com/BBC-BBC2546862-Micro-bit-go/dp/B01G8X7VM2/ref=sr_1_3?keywords=microbit&qid=1556837891&s=gateway&sr=8-3), and the battery of the micro:bit is stored in the handle of the wand. The wand can be seen in the picture below. 

<img src="https://user-images.githubusercontent.com/14846863/57108237-5759d780-6cef-11e9-82b4-d9cfac3aa789.PNG" width="400" title="Wand"></img>

The mechanical button pusher is responsible for physically pressing the elevator buttons. All hardware is mounted to a laser-cut acrylic sheet, shown in the picture below and available in this repo under [`ElevatorAcrylicSheet.sldprt`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/ElevatorAcrylicSheet.sldprt). In the final assembly, [3M Dual Lock tape](https://www.amazon.com/3M-Dual-Lock-Reclosable-Fastener/dp/B007OXK330/ref=sr_1_1_sspa?keywords=3m+dual+lock&qid=1556838467&s=gateway&sr=8-1-spons&psc=1) attaches the mechanism to the elevator panel.
![Bildschirmfoto 2019-05-02 um 4 51 45 PM](https://user-images.githubusercontent.com/46902147/57112208-4368a280-6cfc-11e9-9dce-231ff657809e.png)  

A LEGO assembly is built on the acrylic sheet. Since many different variations of elevator panels exist, we will forgoe a detailed construction manual. However, two critical LEGO components have proven to be suitable for the assembly. First, the LEGO MINDSTORMS Interactive Motor (9842), and second, two LEGO TECHNIC mini linear actuators (92693). Working with gears and belts, the clockwise and counterclockwise rotational movement of the motor can be transferred to extend the two linear actuators in opposing directions. These two LEGO components are shown in the picture below.

![LEGO](https://user-images.githubusercontent.com/46902147/57112560-ce966800-6cfd-11e9-9994-8441402ade01.png)

In addition, the acrylic sheet holds the mentioned Raspberry Pi 3 and BrickPi3 shield. A 12 Volt battery pack can be included to drive the Raspberry Pi, BrickPi, and LEGO motor. However, this load does drain the battery pack quickly. A 12 Volt wall plug is the more stable option. The final assembly is shown in the picture below.

![HardwareDetail](https://user-images.githubusercontent.com/46902147/56911665-a8a56500-6a6a-11e9-80de-c8a03416ab04.png)
 
## Final Report
[`final_report.md`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/final_report.md) in this repo.
