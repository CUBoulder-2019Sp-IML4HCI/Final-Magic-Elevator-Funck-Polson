# The Magic Elevator

## Team Members
 - Max Funck
 - Shawn Polson
 
## Video Demo
https://www.youtube.com/watch?v=wKQm7nsb_Ok

## The Idea
Elevators are both a blessing and a curse. They enable heavy equipment to be transported across levels, and they are often the only means by which people with mobility impairments can move up and down in a building. However, waiting for them in an awkward silence is anything but exciting. The Magic Elevator solves this problem: riders become witches and wizards, summoning their elevator through magic spells. Only a correctly executed spell calls the elevator!

This report describes a minimum viable product (MVP) prototype of a system that accomplishes this idea. The prototype was built by Maximilian Funck and Shawn Polson as part of their Machine Learning for Human-Computer Interaction course (CSCI 5880) at CU Boulder. Witches/wizards wield magic wands that are plastic toy Harry Potter wands whose insides were gutted and replaced with a micro:bit that senses X, Y, and Z acceleration. They perform wand motions with voice incantations that together call the elevator either up or down. The witches/wizards come up with and train the motions and incantations themselves through the Magic Elevator's user interface (UI). When spells are cast correctly, a button-pushing mechanism built almost entirely out of LEGO parts (and a Raspberry Pi 3), which is mounted over the elevator buttons, summons the elevator in the appropriate direction.

Witches/wizards are free to train a new wand motion or set a new incantation for their spells at any time; Professor Flitwick walks them through it in the UI. When two users are present, they must work together to cast agreeing spells to call the elevator in one direction. It's a game; only sufficiently skilled witches/wizards may enter the Magic Elevator! When only one is present, she or he can just call the elevator in single-player mode.

## Mission Statement
Our mission is to provide a Harry Potter–like elevator experience with machine learning technology. The interaction with the input device, a wand, results in a magically activated elevator terminal pressing the buttons to call the elevator. The user experience is designed to be seamless and intuitive, just like magic.

## User Experience
![UserStoryGithub](https://user-images.githubusercontent.com/46902147/56765798-20227e00-6765-11e9-979d-04eb72f43116.png)  

## Building the Project
This repo contains all the software needed to recreate the Magic Elevator. The hardware—wands and the mechanical button pusher—were custom-built, and recreating them isn't trivial. But here we include details for building all aspects of our system. 

### Building the Software
![UserInterface](https://user-images.githubusercontent.com/14846863/56779108-adca9180-6796-11e9-9332-b05396f1e6eb.png)

All the software is shown in the picture above. Here's how to use/build each component.
#### Main UI
The program labeled "Main UI" in the picture above is [`Flitwick_Spell_Training/Flitwick_Spell_Training.pde`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/Flitwick_Spell_Training/Flitwick_Spell_Training.pde) in this repo. It's a self-contained Processing program that will run once you have installed the libraries it imports. It relies on three system fonts that we put in [`Flitwick_Spell_Training/data/`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/tree/master/Flitwick_Spell_Training/data): `4PrivetDrive-Regular.otf`, `HARRP___.TTF`, and `LumosLatino.ttf`.

#### Wand data

#### Classify wand motions

#### Transcribe incantations

#### Change incantations

#### Receive spells

#### LEGO motor control

### Building the Hardware
<img src="https://user-images.githubusercontent.com/14846863/57103067-0d1e2980-6ce2-11e9-8049-d4707d75fbc0.PNG" width="400" title="Wand"></img>
![SolenoidIteration](https://user-images.githubusercontent.com/46902147/56854968-59d9bd00-68fc-11e9-9a6c-6a34c0a055ad.png)
![HardwareDetail](https://user-images.githubusercontent.com/46902147/56911665-a8a56500-6a6a-11e9-80de-c8a03416ab04.png)
 
## Final Report
[`final_report.md`](https://github.com/CUBoulder-2019Sp-IML4HCI/Final-Magic-Elevator-Funck-Polson/blob/master/final_report.md) in this repo.
