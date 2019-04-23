import speech_recognition as sr
from pythonosc import udp_client
from pythonosc import dispatcher
from pythonosc import osc_server
import argparse
import sys                      


class IncantationChanger:
    
    def __init__(self):
        print("Initialized incantation changer.")


    def changeUp(self, unused_data):
        with open('data/up.txt', 'w') as up_file:
            incantation = ''

            # get new incantation from user's voice
            r = sr.Recognizer()
            while(True):
                with sr.Microphone() as source:
                    print('Speak a new UP incantation: ')
                    audio = r.listen(source)

                    try:
                        text = r.recognize_google(audio)
                        incantation = text
                        
                        print('Your new UP incantation is:  {}'.format(incantation))
                        print('')
                        break
                    except Exception as e:
                        print('...')


            up_file.write(incantation)
            up_file.close()

    def changeDown(self, unused_data):
        with open('data/down.txt', 'w') as down_file:
            incantation = ''

            # get new incantation from user's voice
            r = sr.Recognizer()
            while(True):
                with sr.Microphone() as source:
                    print('Speak a new DOWN incantation: ')
                    audio = r.listen(source)

                    try:
                        text = r.recognize_google(audio)
                        incantation = text
                        
                        print('Your new DOWN incantation is:  {}'.format(incantation))
                        print('')
                        break
                    except Exception as e:
                        print('...')

            down_file.write(incantation)
            down_file.close()
        
  
    
if __name__ == "__main__":
    
    # r = sr.Recognizer()
    # client = udp_client.SimpleUDPClient("192.168.195.28", 12000) # zerotier IP of raspberry pi

    changer = IncantationChanger() 

    ip = '127.0.0.1'  
    port = '12002'
    
    # Parse arguments for host ip and port.
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip",
        default=ip, help="The ip to listen on")
    parser.add_argument("--port",
        type=int, default=port, help="The port to listen on")
    args = parser.parse_args()
    
    # Create dispatcher to handle incoming OSC messages.
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/incantation/up", changer.changeUp)
    dispatcher.map("/incantation/down", changer.changeDown)
    
    server = osc_server.ThreadingOSCUDPServer(
            (args.ip, args.port), dispatcher)
        
    print("Serving on {}".format(server.server_address))
    server.serve_forever()
