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
PFont labelFont, buttonFont, headerFont, trainingFont;
int frameNum = 0;
int r = 150; //red component of background color
int g = 200; //green component of background color
int b = 200; //blue component of background color
int currentTextHue = 0;
String currentMessage = "The Magic Elevator";

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
float w3 = 300;
float h3 = h1/2;
//down incantation
String downIncantation;
float x4 = x2+w2+15;
float y4 = y2+(h2/2);
float w4 = 300;
float h4 = h2/2;

//prevent multiple button clicks at once, preventing repeating training cycles
Boolean buttonWasClicked = false;



void setup() {
    size(1000,800, P3D);
    colorMode(RGB);
    background(r,g,b);
    smooth();
    
    
    //Initialize OSC communication
    oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
    wekiDest = new NetAddress("127.0.0.1",8999); //send messages to Wekinator on port 8999, localhost (this machine)
    selfDest = new NetAddress("127.0.0.1",12000); //send messages back to this program
    voiceDest = new NetAddress("127.0.0.1",12002); //send messages to change_incantations_server.py
    
    //Set up fonts
    labelFont = createFont("4 Privet Drive", 30);
    buttonFont = createFont("4 Privet Drive", 40);
    headerFont = createFont("LumosLatino", 50);
    trainingFont = createFont("Harry Potter", 60);
    
    //Initialize incantations from files
    upIncantation = loadStrings("up.txt")[0].trim();
    downIncantation = loadStrings("down.txt")[0].trim();
}

void draw() {
    frameRate(30);
    background(r, g, b);
    drawText();
    
    //Buttons and labels
    if (!buttonWasClicked) { //don't show buttons during training
        //"UP Spell" header
        textFont(headerFont);
        text("UP Spell", 20, y1-80);
    
        //"Train UP" Button
        rect(x1,y1,w1,h1);
        fill(220);
        textFont(buttonFont);
        text("Train Wand", x1+18, y1+20);
        if(mousePressed) {
            if(mouseX>x1 && mouseX <x1+w1 && mouseY>y1 && mouseY <y1+h1) {
                buttonWasClicked = true;
                println("UP wand button clicked.");
                OscMessage msg = new OscMessage("/startTrainingUp");    
                oscP5.send(msg, selfDest);
            }  
        } 
        
        //UP incantation label
        fill(0);
        textFont(labelFont);
        text("Incantation: \"" + upIncantation + "\"", x1+w1+15, y1);
        
        //UP incantation button
        fill(0);
        rect(x3,y3,w3,h3);
        fill(220);
        textFont(labelFont);
        text("Change Incantation", x3+8, y3+2);
        if(mousePressed) {
            if(mouseX>x3 && mouseX <x3+w3 && mouseY>y3 && mouseY <y3+h3) {
                buttonWasClicked = true;
                println("UP incantation button clicked.");
                OscMessage msg = new OscMessage("/changeIncantationUp");    
                oscP5.send(msg, selfDest); 
            }  
        }
        
        
        //"DOWN Spell" Header
        fill(0);
        textFont(headerFont);
        text("DOVN Spell", 20, y2-80); //note 'V' is 'W' in LumosLatino for some reason...
    
        //"Train DOWN" Button
        fill(0);
        rect(x2,y2,w2,h2);
        fill(220);
        textFont(buttonFont);
        text("Train Wand", x2+18, y2+20);
        if(mousePressed) {
            if(mouseX>x2 && mouseX <x2+w2 && mouseY>y2 && mouseY <y2+h2) {
                buttonWasClicked = true;
                println("DOWN wand button clicked.");
                OscMessage msg = new OscMessage("/startTrainingDown");    
                oscP5.send(msg, selfDest); 
            }  
        }
        
        //DOWN incantation label
        fill(0);
        textFont(labelFont);
        text("Incantation: \"" + downIncantation + "\"", x2+w2+15, y2);
        
        //DOWN incantation button
        fill(0);
        rect(x4,y4,w4,h4);
        fill(220);
        textFont(labelFont);
        text("Change Incantation", x4+8, y4+2);
        if(mousePressed) {
            if(mouseX>x4 && mouseX <x4+w4 && mouseY>y4 && mouseY <y4+h4) {
                buttonWasClicked = true;
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
        String origMessage = currentMessage;
        
        //Tell user they're training a new gesture
        currentMessage = "Okay! Let's train a new \nwand gesture for " + spell + ".";
        delay(5000);
        currentMessage = "I will erase the current gesture \nin one moment...";
        delay(3000);
        
        //Clear examples for UP or DOWN depending on spell
        deleteAllExamples(spell);
        changeBackgroundColor(140, 150, 160); //grey
        currentMessage = "Erased!\nNow let's train that new gesture.";
        delay(3000);
        
        //Prepare the user for the upcoming 10 training cycles
        currentMessage = "Get your wand ready.";
        delay(3000);
        currentMessage = "I'll count down from 5,\nand once I say 'GO!'\nI'll have you perform the gesture \n10 times.\nYou'll have about a second each time.";
        delay(8000);
        currentMessage = "Ready?";
        delay(3000);
    
        //Count down from 5...
        changeBackgroundColor(110, 195, 220);
        currentMessage = "5...";
        delay(1000);
        currentMessage = "4...";
        delay(1000);
        currentMessage = "3...";
        delay(1000);
        currentMessage = "2...";
        delay(1000);
        currentMessage = "1...";
        delay(1000);
        
        //Prompt the user to record their 10 new gesture training examples
        for (int i = 1; i <= 10; i++) { 
            changeBackgroundColor(45,237,205); //green
            if (i == 1) currentMessage = "GO!\nSTART GESTURE (" + i + ")";
            else currentMessage = "START GESTURE (" + i + ")";
            startDtwRecording(spell);
            
            delay(1500); //record for exactly 1.5 seconds
            
            changeBackgroundColor(237,45,93); //red
            currentMessage = "STOP GESTURE";
            stopDtwRecording();
            delay(2000);
        }
        
        //Congratulate the user and run Wekinator with their new gesture
        changeBackgroundColor(150,200,200);
        currentMessage = "Great spell casting!\nNow try out your new gesture.";
        delay(3000);
        currentMessage = origMessage;
        startRunning();
        
        //Allow the training button to be clicked again now that this cycle ended
        buttonWasClicked = false;
    }
}

/**
 * This is the logic for changing the incantation (vocal component) of the spells.
 * Note that this will hang forever if you don't actually change the incantation to something new.
 */ 
void changeIncantation(String spell) {
    if (spell.equals("UP") || spell.equals("DOWN")) { //assert spell must be "UP" or "DOWN"
        String oldMessage = currentMessage;
        String oldIncantation = spell.equals("UP") ? upIncantation : downIncantation;
        String newIncantation = oldIncantation;
        String fileName = spell.equals("UP") ? "up.txt" : "down.txt";
        
        currentMessage = "Changing " + spell + " incantation...";
        
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
            }
            catch(Exception e) {
                //no-op
            } 
        }
        
        if (spell.equals("UP")) upIncantation = newIncantation;
        else                    downIncantation = newIncantation;
        
        currentMessage = oldMessage;
        buttonWasClicked = false;
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
    stroke(0);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 0, 0);
    
    textFont(trainingFont);
    text(currentMessage, 20, 180);
}
