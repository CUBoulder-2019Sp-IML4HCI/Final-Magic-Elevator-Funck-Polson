from pythonosc import dispatcher
from pythonosc import osc_server
import pygame
import numpy as np
import argparse
import sys

class MotorController:
    
    def __init__(self):
        print("Initialized.")


    def call_up(self, signal_name, data, x, y):
        print("Called up!")
        print("signal_name:")
        print(signal_name)
        print("data:")
        print(data)
            
            
    def call_down(self, signal_name, data):
        print("Called down!")
        print("signal_name:")
        print(signal_name)
        print("data:")
        print(data)
         
         
    
    
if __name__ == "__main__":
    ctrl = MotorController()

    ip = '127.0.0.1'  # pi ip: 192.168.195.28
    port = '12000'
    
    # Parse arguments for host ip and port.
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip",
        default=ip, help="The ip to listen on")
    parser.add_argument("--port",
        type=int, default=port, help="The port to listen on")
    args = parser.parse_args()
    
    # Create dispatcher to handle incoming OSC messages.
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/wek/outputs", ctrl.call_up)
    dispatcher.map("/wek/singer", ctrl.call_down)
    
    server = osc_server.ThreadingOSCUDPServer(
            (args.ip, args.port), dispatcher)
        
    print("Serving on {}".format(server.server_address))
    server.serve_forever()

