//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
OscP5 oscP5;
NetAddress wekiDest;
NetAddress selfDest;
NetAddress voiceDest;

//Variables for displaying on-screen text 
PFont labelFont, buttonFont, headerFont, titleFont, trainingFont;
int frameNum = 0;
int r = 150; //red component of background color
int g = 200; //green component of background color
int b = 200; //blue component of background color
int textR = 255;
int textG = 255;
int textB = 255;
String currentMessage = "The Magic Elevator";
int textX = 30;
int textY = 700;

//Variables for train buttons
//up gesture
float x1 = 100;
float y1 = 400;
float w1 = 300;
float h1 = 90;
//down gesture
float x2 = 100;
float y2 = 650;
float w2 = 300;
float h2 = 90;
//up incantation
String upIncantation;
float x3 = x1+w1+15;
float y3 = y1+(h1/2);
float w3 = 285;
float h3 = h1/2;
//down incantation
String downIncantation;
float x4 = x2+w2+15;
float y4 = y2+(h2/2);
float w4 = 285;
float h4 = h2/2;

//prevent multiple button clicks at once, preventing repeating training cycles
Boolean showButtons = true;

//Variables for background images
PImage mainBackground;
PImage mainBackgroundBlurred;
PImage flitwick1;
PImage flitwick2;
PImage flitwickGreen;
PImage flitwickRed;
PImage currentBackground;

//Variables for sound
Minim minim;
AudioPlayer harryPotterSong;


void setup() {
    size(1000,800, P3D);
    colorMode(RGB);
    background(25,25,25);
    smooth();
    
    
    //Initialize OSC communication
    oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
    wekiDest = new NetAddress("127.0.0.1",8999); //send messages to Wekinator on port 8999, localhost (this machine)
    selfDest = new NetAddress("127.0.0.1",12000); //send messages back to this program
    voiceDest = new NetAddress("127.0.0.1",12002); //send messages to change_incantations_server.py
    
    //Set up fonts
    labelFont = createFont("4 Privet Drive", 27);
    buttonFont = createFont("4 Privet Drive", 40);
    headerFont = createFont("LumosLatino", 50);
    titleFont = createFont("Harry Potter", 60);
    trainingFont = createFont("4 Privet Drive", 35);
    
    //Initialize incantations from files
    upIncantation = loadStrings("up.txt")[0].trim();
    downIncantation = loadStrings("down.txt")[0].trim();
    
    //Initialize background images
    mainBackground = loadImage("magicLifts.jpg");
    mainBackgroundBlurred = loadImage("magicLiftsBlurred.jpg");
    flitwick1 = loadImage("flitwickBlackBottom.jpg");
    flitwick2 = loadImage("flitwickWandBlackBottom.jpg");
    flitwickGreen = loadImage("flitwickWandGreen.jpg");
    flitwickRed = loadImage("flitwickWandRed.jpg");
    currentBackground = mainBackground;
    
    //Initialize Harry Potter song
    minim = new Minim(this);
    harryPotterSong = minim.loadFile("Harry Potter Theme Song.mp3");
}

void draw() {
    frameRate(30);
    //background(r, g, b);
    image(currentBackground, 0, 0);
    drawText();
    
    //Buttons and labels
    if (showButtons) { //don't show buttons during training
        //"UP Spell" header
        textFont(headerFont);
        text("UP Spell", 20, y1-80);
    
        //"Train UP" Button
        fill(210);
        rect(x1,y1,w1,h1);
        fill(0);
        textFont(buttonFont);
        text("Train Wand", x1+18, y1+22);
        if(mousePressed) {
            if(mouseX>x1 && mouseX <x1+w1 && mouseY>y1 && mouseY <y1+h1) {
                showButtons = false;
                println("UP wand button clicked.");
                OscMessage msg = new OscMessage("/startTrainingUp");    
                oscP5.send(msg, selfDest);
            }  
        } 
        
        //UP incantation label
        fill(255);
        textFont(labelFont);
        text("Incantation: “" + upIncantation + "\"", x1+w1+15, y1);
        
        //UP incantation button
        fill(210);
        rect(x3,y3,w3,h3);
        fill(0);
        textFont(labelFont);
        text("Change Incantation", x3+16, y3+5);
        if(mousePressed) {
            if(mouseX>x3 && mouseX <x3+w3 && mouseY>y3 && mouseY <y3+h3) {
                showButtons = false;
                println("UP incantation button clicked.");
                OscMessage msg = new OscMessage("/changeIncantationUp");    
                oscP5.send(msg, selfDest); 
            }  
        }
        
        
        //"DOWN Spell" Header
        fill(255);
        textFont(headerFont);
        text("DOVN Spell", 20, y2-80); //note 'V' is 'W' in LumosLatino for some reason...
    
        //"Train DOWN" Button
        fill(210);
        rect(x2,y2,w2,h2);
        fill(0);
        textFont(buttonFont);
        text("Train Wand", x2+18, y2+22);
        if(mousePressed) {
            if(mouseX>x2 && mouseX <x2+w2 && mouseY>y2 && mouseY <y2+h2) {
                showButtons = false;
                println("DOWN wand button clicked.");
                OscMessage msg = new OscMessage("/startTrainingDown");    
                oscP5.send(msg, selfDest); 
            }  
        }
        
        //DOWN incantation label
        fill(255);
        textFont(labelFont);
        text("Incantation: “" + downIncantation + "\"", x2+w2+15, y2);
        
        //DOWN incantation button
        fill(210);
        rect(x4,y4,w4,h4);
        fill(0);
        textFont(labelFont);
        text("Change Incantation", x4+16, y4+5);
        if(mousePressed) {
            if(mouseX>x4 && mouseX <x4+w4 && mouseY>y4 && mouseY <y4+h4) {
                showButtons = false;
                println("DOWN incantation button clicked.");
                OscMessage msg = new OscMessage("/changeIncantationDown");    
                oscP5.send(msg, selfDest); 
            }  
        }
    }
}

/**
 * This is the main logic for training new wand gestures
 */ 
void startTraining(String spell) {
    if (spell.equals("UP") || spell.equals("DOWN")) { //assert spell must be "UP" or "DOWN"
        harryPotterSong.play(); //Play
        currentBackground = flitwick1;
        String origMessage = currentMessage;
        
        //Introduce Flitwick and tell user they're training a new wand motion
        textX = 30;
        textY = 700;
        currentMessage = "Greetings, I am Filius Flitwick, your Charms professor!";
        delay(2000);
        currentMessage = "Greetings, I am Filius Flitwick, your Charms professor!\n...";
        delay(1000);
        currentMessage = "Greetings, I am Filius Flitwick, your Charms professor!\n..";
        delay(1000);
        currentMessage = "Greetings, I am Filius Flitwick, your Charms professor!\n.";
        delay(1000);
        currentMessage = "Greetings, I am Filius Flitwick, your Charms professor!";
        int origTextX = textX;
        textX = spell.equals("DOWN") ? 20 : textX; //"DOWN" almost puts text off-screen, so adjust
        currentMessage = "Let's learn a new wand motion for " + spell + ", shall we?";
        delay(2000);
        currentMessage = "Let's learn a new wand motion for " + spell + ", shall we?\n...";
        delay(1000);
        currentMessage = "Let's learn a new wand motion for " + spell + ", shall we?\n..";
        delay(1000);
        currentMessage = "Let's learn a new wand motion for " + spell + ", shall we?\n.";
        delay(1000);
        currentMessage = "Let's learn a new wand motion for " + spell + ", shall we?";
        
        //Clear examples for UP or DOWN depending on spell
        textX = origTextX; //move text back if we moved it
        deleteAllExamples(spell);
        currentMessage = "You decide what that motion will be.";
        delay(500);
        currentMessage = "You decide what that motion will be.\n...";
        delay(1000);
        currentMessage = "You decide what that motion will be.\n..";
        delay(1000);
        currentMessage = "You decide what that motion will be.\n.";
        delay(1000);
        currentMessage = "You decide what that motion will be.";
        
        //Prepare the user for the upcoming 10 training cycles
        currentMessage = "Get your wand ready.";
        delay(3000);
        currentMessage = "Get your wand ready.\n...";
        delay(1000);
        currentMessage = "Get your wand ready.\n..";
        delay(1000);
        currentMessage = "Get your wand ready.\n.";
        delay(1000);
        currentMessage = "Get your wand ready.";

        currentBackground = flitwick2;
        textY = 570;
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.";
        delay(4000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t......";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t.....";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t....";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t...";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t..";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.\t.";
        delay(1000);
        currentMessage = "I'll count down from 5, and once I say 'GO!'\nI'll have you perform your motion 10 times.\n\nYou will have about a second each time.";
        
        currentMessage = "Ready?";
        delay(3000);
    
        //Count down from 5...
        changeBackgroundColor(110, 195, 220);
        currentMessage = "Ready?\n\n5...";
        delay(1000);
        currentMessage = "Ready?\n\n5... 4...";
        delay(1000);
        currentMessage = "Ready?\n\n5... 4... 3...";
        delay(1000);
        currentMessage = "Ready?\n\n5... 4... 3... 2...";
        delay(1000);
        currentMessage = "Ready?\n\n5... 4... 3... 2... 1...";
        delay(1000);
        
        //Prompt the user to record their 10 new gesture training examples
        for (int i = 1; i <= 10; i++) { 
            currentBackground = flitwickGreen;
            if (i == 1) currentMessage = "GO!\nSTART MOTION (" + i + ")";
            else currentMessage = "\nSTART MOTION (" + i + ")";
            startDtwRecording(spell);
            
            delay(1500); //record for exactly 1.5 seconds
            
            currentBackground = flitwickRed;
            currentMessage = "\nSTOP";
            stopDtwRecording();
            delay(2000);
        }
        
        //Congratulate the user and run Wekinator with their new gesture
        currentBackground = flitwick1;
        textY = 675;
        currentMessage = "Great spell casting!\nNow try out your new wand motion, why don't you?";
        delay(6000);
        
        //Set things back for the main screen
        currentBackground = mainBackground;
        currentMessage = origMessage;
        startRunning();
        harryPotterSong.pause();
        harryPotterSong.rewind();
        
        //Allow the training buttons to be clicked again now that this cycle ended
        showButtons = true;
    }
}

/**
 * This is the logic for changing the incantation (vocal component) of the spells.
 * Note that this will hang forever if you don't actually change the incantation to something new.
 */ 
void changeIncantation(String spell) {
    if (spell.equals("UP") || spell.equals("DOWN")) { //assert spell must be "UP" or "DOWN"
        currentBackground = mainBackgroundBlurred;
        String oldMessage = currentMessage;
        String oldIncantation = spell.equals("UP") ? upIncantation : downIncantation;
        String newIncantation = oldIncantation;
        String fileName = spell.equals("UP") ? "up.txt" : "down.txt";
        int periodCounter = 1;
        textX = 50;
        
        currentMessage = "Speak a new " + spell + " incantation.";
        
        //trigger change_incantations_server.py
        OscMessage msg;
        if (spell.equals("UP")) msg = new OscMessage("/incantation/up");
        else                    msg = new OscMessage("/incantation/down");
        oscP5.send(msg, voiceDest); 
        
        delay(3000);
        
        //wait indefinitely for the incantation to change. TODO: cap the wait at some number of seconds
        while (newIncantation.equals(oldIncantation)) {
            try {
                newIncantation = loadStrings(fileName)[0].trim();
                //animate ellipsis...
                switch(periodCounter) {
                    case 1: 
                        periodCounter = 2;
                        currentMessage = "Speak a new " + spell + " incantation..";
                        delay(1000);
                        break;
                    case 2:
                        periodCounter = 3;
                        currentMessage = "Speak a new " + spell + " incantation...";
                        delay(1000);
                        break;
                    case 3:
                        periodCounter = 1;
                        currentMessage = "Speak a new " + spell + " incantation.";
                        delay(1000);
                        break;
                }  
            }
            catch(Exception e) {
                //no-op
                //still animate ellipsis...
                switch(periodCounter) {
                    case 1: 
                        periodCounter = 2;
                        currentMessage = "Speak a new " + spell + " incantation..";
                        delay(1000);
                        break;
                    case 2:
                        periodCounter = 3;
                        currentMessage = "Speak a new " + spell + " incantation...";
                        delay(1000);
                        break;
                    case 3:
                        periodCounter = 1;
                        currentMessage = "Speak a new " + spell + " incantation.";
                        delay(1000);
                        break;
                }  
            } 
        }
        
        if (spell.equals("UP")) upIncantation = newIncantation;
        else                    downIncantation = newIncantation;
        
        textX = 30;
        currentMessage = oldMessage;
        currentBackground = mainBackground;
        showButtons = true;
    }
}

//------Helper Methods-------------------------------------------------------

/**
 * This is called automatically when OSC messages are received
 */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/startTrainingUp") == true) {
      println("Starting training wand UP.");
      startTraining("UP");
  }
  else if (theOscMessage.checkAddrPattern("/startTrainingDown") == true) {
      println("Starting training wand DOWN.");
      startTraining("DOWN");
  }
  else if (theOscMessage.checkAddrPattern("/changeIncantationUp") == true) {
      println("Changing voice for UP.");
      changeIncantation("UP");
  }
  else if (theOscMessage.checkAddrPattern("/changeIncantationDown") == true) {
      println("Changing voice for DOWN.");
      changeIncantation("DOWN");
  }
}

void stopRunning() {
    OscMessage msg = new OscMessage("/wekinator/control/stopRunning");
    oscP5.send(msg, wekiDest);
}

void startRunning() {
    OscMessage msg = new OscMessage("/wekinator/control/startRunning");
    oscP5.send(msg, wekiDest);
}

void deleteAllExamples(String upOrDown) {
    int gestureNum;
    if (upOrDown.equals("UP")) gestureNum = 1; //TODO: trying to delete all UP examples seems to kill Wekinator...
    else gestureNum = 2;
  
    OscMessage msg = new OscMessage("/wekinator/control/deleteExamplesForOutput");
    msg.add(gestureNum); //1 specifies the first DTW gesture, which is UP; 2 is DOWN
    oscP5.send(msg, wekiDest);
}

void startDtwRecording(String upOrDown) {
    int gestureNum;
    if (upOrDown.equals("UP")) gestureNum = 1; 
    else gestureNum = 2;
    
    OscMessage msg = new OscMessage("/wekinator/control/startDtwRecording");
    msg.add(gestureNum); //1 specifies the first DTW gesture, which is UP; 2 is DOWN
    oscP5.send(msg, wekiDest);
}

void stopDtwRecording() {
    OscMessage msg = new OscMessage("/wekinator/control/stopDtwRecording");
    oscP5.send(msg, wekiDest);
}

void changeBackgroundColor(int red, int green, int blue) {
    r = red; g = green; b = blue;
}

//Write instructions (i.e. currentMessage) to the screen.
void drawText() {
    if (showButtons) { //Text on main screen
        stroke(0);
        textAlign(LEFT, TOP); 
        fill(textR, textG, textB);
        
        textFont(titleFont);
        text(currentMessage, 20, 110);
    } else { //Text during training
          textAlign(LEFT, TOP); 
          fill(textR, textG, textB);
          
          textFont(trainingFont);
          text(currentMessage, textX, textY);
    }
}
