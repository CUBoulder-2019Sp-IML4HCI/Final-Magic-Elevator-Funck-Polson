//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
OscP5 oscP5;
NetAddress wekiDest;
NetAddress selfDest;

//Variables for displaying on-screen text 
PFont myFont, myBigFont;
int frameNum = 0;
int r = 150; //red component of background color
int g = 200; //green component of background color
int b = 200; //blue component of background color
int currentTextHue = 0;
String currentMessage = "Waiting...";

//Variables for train buttons
float x1 = 100;
float y1 = 700;
float w1 = 250;
float h1 = 90;

float x2 = 400;
float y2 = 700;
float w2 = 350;
float h2 = 90;

//small hack to prevent multiple button clicks at once, preventing repeating training cycles
Boolean trainUpWasClicked = false;
Boolean trainDownWasClicked = false;



void setup() {
    size(1000,800, P3D);
    colorMode(RGB);
    background(r,g,b);
    smooth();
    
    //Initialize OSC communication
    oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
    wekiDest = new NetAddress("127.0.0.1",8999); //send messages to Wekinator on port 8999, localhost (this machine)
    selfDest = new NetAddress("127.0.0.1",12000); //send messages back to this program
    
    //Set up fonts
    myFont = createFont("Arial", 14);
    myBigFont = createFont("Arial", 60);
}

void draw() {
    frameRate(30);
    background(r, g, b);
    drawText();
    
    //"Train UP" Button
    rect(x1,y1,w1,h1);
    fill(220);
    text("Train UP", 105, 710);
    if(mousePressed) {
        if(mouseX>x1 && mouseX <x1+w1 && mouseY>y1 && mouseY <y1+h1) {
            if (!trainUpWasClicked) {
                trainUpWasClicked = true;
                println("UP button clicked.");
                OscMessage msg = new OscMessage("/startTrainingUp");    
                oscP5.send(msg, selfDest);
            }
        }  
    } 
    
    //"Train DOWN" Button
    fill(0);
    rect(x2,y2,w2,h2);
    fill(220);
    text("Train DOWN", 405, 710);
    if(mousePressed) {
        if(mouseX>x2 && mouseX <x2+w2 && mouseY>y2 && mouseY <y2+h2) {
            if (!trainDownWasClicked) {
                trainDownWasClicked = true;
                println("DOWN button clicked.");
                OscMessage msg = new OscMessage("/startTrainingDown");    
                oscP5.send(msg, selfDest);
            }
        }  
    }     
}

/**
 * This is the main logic for this whole program
 */ 
void startTraining(String spell) {
    if (spell.equals("UP") || spell.equals("DOWN")) { //assert spell must be "UP" or "DOWN"
        
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
        currentMessage = "I'll count down from 5,\nand once I say 'GO!'\nI'll have you perform the gesture \n10 times.\nYou'll have 2 seconds each time.";
        delay(9000);
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
            
            delay(2000); //record for exactly 2 seconds
            
            changeBackgroundColor(237,45,93); //red
            currentMessage = "STOP GESTURE";
            stopDtwRecording();
            delay(2000);
        }
        
        //Congratulate the user and run Wekinator with their new gesture
        changeBackgroundColor(150,200,200);
        currentMessage = "Great spell casting!\nNow try out your new gesture.";
        startRunning();
        
        //Allow the training button to be clicked again now that this cycle ended
        if (spell.equals("UP"))        trainUpWasClicked = false;
        else if (spell.equals("DOWN")) trainDownWasClicked = false;
    }
}

//------Helper Methods-------------------------------------------------------

/**
 * This is called automatically when OSC messages are received
 */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/startTrainingUp") == true) {
      println("Starting training UP.");
      startTraining("UP");
  }
  else if (theOscMessage.checkAddrPattern("/startTrainingDown") == true) {
      println("Starting training DOWN.");
      startTraining("DOWN");
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
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 0, 0);
    
    textFont(myBigFont);
    text(currentMessage, 20, 180);
}

