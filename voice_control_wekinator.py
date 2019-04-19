import speech_recognition as sr
import time
from pythonosc import udp_client

r = sr.Recognizer()
client = udp_client.SimpleUDPClient("localhost", 8999)

while(True):
    with sr.Microphone() as source:
        print('Speak Anything: ')
        audio = r.listen(source)

        try:
            text = r.recognize_google(audio)

            # voice commads to start Processing code that trains new gestures
            if ('begin training up' in text):
                client = udp_client.SimpleUDPClient("localhost", 12000)
                client.send_message("/startTrainingUp", 0 )
                client = udp_client.SimpleUDPClient("localhost", 8999) 
            elif ('begin training down' in text):
                client = udp_client.SimpleUDPClient("localhost", 12000)
                client.send_message("/startTrainingDown", 0 )
                client = udp_client.SimpleUDPClient("localhost", 8999) 

            # assortment of voice commands to control Wekinator directly
            elif ('start running' in text ):
                client.send_message("/wekinator/control/startRunning", 0 )
            elif ('stop running' in text):
                client.send_message("/wekinator/control/stopRunning", 0 )
            elif ('start recording up' in text):
                client.send_message("/wekinator/control/startDtwRecording", 1 )
                time.sleep(2)  # record for exactly 2 seconds
                client.send_message("/wekinator/control/stopDtwRecording", 0 )
            elif ('start recording down' in text):
                client.send_message("/wekinator/control/startDtwRecording", 2 )
                time.sleep(2)  # record for exactly 2 seconds
                client.send_message("/wekinator/control/stopDtwRecording", 0 )
            elif ('start recording default' in text):
                client.send_message("/wekinator/control/startDtwRecording", 3)
                time.sleep(2)  # record for exactly 2 seconds
                client.send_message("/wekinator/control/stopDtwRecording", 0 )
            # elif ('stop recording' in text):
            #     client.send_message("/wekinator/control/stopDtwRecording", 0 )
            # TODO: "deleteExamplesForOutput" (with 1, 2, or 3) to support deleting bad DTW recordings?
            
            print('You said:  {}'.format(text))
        except Exception as e:
            print(e)
            print('Sorry, did not hear/recognize your voice.')
            
