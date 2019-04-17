import time
from pythonosc import udp_client


client = udp_client.SimpleUDPClient("localhost", 8999)

   
print("Okay! Let's train a new gesture for UP.")
time.sleep(2)
print("I will erase the current gesture in one moment...")
time.sleep(3)
client.send_message("/wekinator/control/stopRunning", 0 ) # stop running
client.send_message("/wekinator/control/deleteExamplesForOutput", 1 ) # delete all UP gestures
print("Erased! Now let's train that new gesture.\n")
time.sleep(2)

print("Get your wand ready.")
time.sleep(2)
print("I'll count down from 5, and once I say GO! I'll have you perform the gesture 10 times.")
print("You'll have 2 seconds each time.")
time.sleep(5)
print("Ready?")
time.sleep(2)

print("5...")
time.sleep(1)
print("4...")
time.sleep(1)
print("3...")
time.sleep(1)
print("2...")
time.sleep(1)
print("1...")
time.sleep(1)
print("\nGO!")

for i in range(1, 11):
    print("START GESTURE (" + str(i) + ")")

    client.send_message("/wekinator/control/startDtwRecording", 1 )  # start recording UP
    time.sleep(2)  # record for exactly 2 seconds

    print("STOP GESTURE")
    client.send_message("/wekinator/control/stopDtwRecording", 0 ) # stop recording UP
    time.sleep(1.5)

print("Great spell casting! Now try out your new gesture.")

client.send_message("/wekinator/control/startRunning", 0 )  # start running the model again




            
