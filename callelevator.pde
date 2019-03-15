import oscP5.*;
import netP5.*;
import processing.io.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


int numUp = 0;
int numDown = 0;
int threshold = 50;
int state = 1;
int suggestion = 1;

public void settings() {
  size(400, 400);
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
  //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    float value = theOscMessage.get(0).floatValue();
    suggestion = int(value);
      
    int nextState = determineState((int)suggestion);
    println("received: " + suggestion + "  numUp: " + numUp + "  numDown: " + numDown + "  state: " + nextState);
    activateSolenoid(nextState);
    }
  }


int determineState(int suggestion) {
    int nextState = suggestion;
    
    switch(state) { 
        case 1: //Pilot is awake
            if (suggestion == 2) { //Don't flip to the drowsy state until threshold is met
                numUp++;
                if (numUp >= threshold) {
                    nextState = 2;
                    suggestion = 1;
                    //state change determined, reset the counts
                    numUp = 0;
                    numDown = 0;
                } else {
                    nextState = 1;
                    suggestion = 1;
                }
            }
            else if (suggestion == 3) { //Don't flip to the asleep state until threshold is met
                numDown++;
                if (numDown >= threshold) {
                    nextState = 3; 
                    suggestion = 1;
                    //state change determined, reset the counts
                    numUp = 0;
                    numDown = 0;
                } else {
                    nextState = 1;
                    suggestion = 1;//ignore suggestion
                }
            }
            break;
        case 2: //Pilot is drowsy
            if (suggestion == 1) {
                //numSleepDetections = 0; //no threshold for wakefulness, don't carry over suspicion of sleepiness 
            }
            if (suggestion == 3) { //Don't flip to the asleep state until threshold is met
                numDown++;
                if (numDown >= threshold) {
                    nextState = 3;  
                    //state change determined, reset the count
                    numDown = 0;
                } else {
                    nextState = 2; 
                }
            }
            break;
        case 3: //Pilot is asleep
            //no threshold for waking up
            numDown = 0;
            numUp = 0;
            nextState =1;
            break;
        default:
            println("Default reached for some reason.");
            break;
       
    }
    
    return nextState;  
}


void activateSolenoid(int nextState) 
{
  // Making the led HIGH or LOW depending on the output from the wekinator
    if (nextState == 1)
  {

    
     println("No Gesture");
  }
  
  
  else if (nextState == 2)
  {
    GPIO.digitalWrite(20, GPIO.LOW);
    delay(1000);
    GPIO.digitalWrite(20, GPIO.HIGH);
    delay(1000); 
    println("Elevator is called going up");  
    nextState = 1;
    suggestion = 1;
return;
  }
  else if (nextState == 3)
  {
    GPIO.digitalWrite(26, GPIO.LOW);
    delay(1000);
    GPIO.digitalWrite(26, GPIO.HIGH);
    delay(1000);
    println("Elevator is called going down");
    nextState = 1;
    suggestion = 1;
return;
  }
}
