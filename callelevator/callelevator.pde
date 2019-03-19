import oscP5.*;
import netP5.*;
import processing.io.*;


//Define global variables
OscP5 oscP5;
NetAddress myRemoteLocation;


public void settings() {
    size(100, 100); // Note, this is just a blank window that can be closed without consequence 
}


void setup() {
    GPIO.pinMode(26, GPIO.OUTPUT);
    GPIO.pinMode(20, GPIO.OUTPUT);
    GPIO.digitalWrite(26, GPIO.HIGH);
    GPIO.digitalWrite(20, GPIO.HIGH);
  
    frameRate(0.01);
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, "0.0.0.0",  12000, OscP5.UDP);
}


// Recieve OSC messages from Wekinator
void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern("/output_1") == true) {
        println("/output_1 recieved.");
        activateSolenoid("UP");
    }
    else if (theOscMessage.checkAddrPattern("/output_2") == true) {
        println("/output_2 recieved.");
        activateSolenoid("DOWN");
    }
    else if (theOscMessage.checkAddrPattern("/output_3") == true) {
        // no-op
    }
}


// Activate a solenoid based on which spell was cast
void activateSolenoid(String spell) {
    // Making the led HIGH or LOW depending on the output from the wekinator
    if (spell.equals("UP")) {
        GPIO.digitalWrite(20, GPIO.LOW);
        delay(1000);
        GPIO.digitalWrite(20, GPIO.HIGH);
        delay(1000); 
        println("Elevator is called going up.\n");  
    }
    else if (spell.equals("DOWN")) {
        GPIO.digitalWrite(26, GPIO.LOW);
        delay(1000);
        GPIO.digitalWrite(26, GPIO.HIGH);
        delay(1000);
        println("Elevator is called going down.\n");
    }
    else {
        // no-op
    }
}
