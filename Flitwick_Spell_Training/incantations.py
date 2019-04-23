import speech_recognition as sr
from pythonosc import udp_client

r = sr.Recognizer()
ip = '192.168.195.28'  # zerotier IP of raspberry pi
client = udp_client.SimpleUDPClient(ip, 12000)

while(True):
    with open('data/up.txt') as uf:
        with open('data/down.txt') as df:
            with sr.Microphone() as source:
                print('Speak Anything: ')
                audio = r.listen(source)

                try:
                    up_incantation = uf.read().strip()
                    down_incantation = df.read().strip()
                    text = r.recognize_google(audio)

                    if (up_incantation in text):
                        print('UP MATCH')
                        client.send_message('/up_voice', 1 )
                    elif (down_incantation in text):
                        print('DOWN MATCH')
                        client.send_message('/down_voice', 2 )
                    
                    print('You said:  {}'.format(text))
                    print('')
                except Exception as e:
                    print('Sorry, could not understand your voice.')
                