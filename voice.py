import speech_recognition as sr
from pythonosc import udp_client

r = sr.Recognizer()
ip = "192.168.195.28"  # zerotier IP of raspberry pi
client = udp_client.SimpleUDPClient(ip, 12000)

while(True):
    with sr.Microphone() as source:
        print('Speak Anything: ')
        audio = r.listen(source)

        try:
            text = r.recognize_google(audio)
            if ('elevator go up' in text or 'go up' in text):
            	client.send_message("/up_voice", 1 )
            elif ('elevator go down' in text or 'go down' in text):
            	client.send_message("/down_voice", 2 )
            
            print('You said:  {}'.format(text))
            print('')
        except Exception as e:
            print('Sorry, could not hear/recognize your voice.')
            
