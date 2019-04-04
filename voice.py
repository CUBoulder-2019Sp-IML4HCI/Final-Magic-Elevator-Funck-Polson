import speech_recognition as sr
from pythonosc import udp_client

r = sr.Recognizer()
client = udp_client.SimpleUDPClient("localhost", 12000)

while(True):
    with sr.Microphone() as source:
        print('Speak Anything: ')
        audio = r.listen(source)

        try:
            text = r.recognize_google(audio)
            if (text == 'elevator go up' or text == 'go up'):
            	client.send_message("/up_voice", 1 )
            elif (text == 'elevator go down' or text == 'go down'):
            	client.send_message("/down_voice", 2 )
            
            print('You said:  {}'.format(text))
        except Exception as e:
            print(e)
            print('Sorry, could not recognize your voice!')
            
