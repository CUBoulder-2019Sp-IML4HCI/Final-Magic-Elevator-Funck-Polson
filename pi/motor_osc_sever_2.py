#!/usr/bin/env python
#
# 
# This code runs the NXT motor to move it in a postion that presses either the up or down elevator button, depending on the OSC message received. 
# Hardware: Connect the NXT motor to the BrickPi3 motor port A. Make sure that the BrickPi3 is running on a 9v power supply.
#
# Results:  When you run this program, send OSC messages to it and the motor will move correspondingly.

from __future__ import print_function # use python 3 syntax but make it compatible with python 2
from __future__ import division       #   

from pythonosc import dispatcher
from pythonosc import osc_server
import argparse
import sys      #                        ''

import time     # import the time library for the sleep function
import brickpi3 # import the BrickPi3 drivers


class MotorController:
    
    def __init__(self, bp):
        self.BP = bp
        # Positions assume motor is at 0 when code starts
        self.press_up = -3050    
        self.press_down = 2700
        self.num_ups = 0
        self.num_downs = 0
        print("Initialized LEGO motor for two people.")


    def call_up(self, signal_name, data):
        self.num_ups = self.num_ups + 1

        if (self.should_call_elevator('up') == True):
            target = self.press_up
            BP.set_motor_position(BP.PORT_A, target)    # set motor A's target position to the current position of motor D
            print("Pressed UP: Motor A target: %6d  Motor A position: %6d" % (target, BP.get_motor_encoder(BP.PORT_A)))
            time.sleep(10.0)  # delay for 10.0 seconds
            BP.set_motor_position(BP.PORT_A, 0)  # reset motor position    
            
    def call_down(self, signal_name, data):
        self.num_downs = self.num_downs + 1

        if (self.should_call_elevator('down') == True):
            target = self.press_down
            BP.set_motor_position(BP.PORT_A, target)    # set motor A's target position to the current position of motor D
            print("Pressed DOWN: Motor A target: %6d  Motor A position: %6d" % (target, BP.get_motor_encoder(BP.PORT_A)))
            time.sleep(10.0)  # delay for 10.0 seconds
            BP.set_motor_position(BP.PORT_A, 0)  # reset motor position

    def should_call_elevator(self, direction):
        if (direction == 'up'):
            if (self.num_ups > 1):
                print('Received 2nd UP spell.')
                self.num_ups = 0
                return True
            else:
                print('Received 1st UP spell.')
                return False

        elif (direction == 'down'):
            if (self.num_downs > 1):
                print('Received 2nd DOWN spell.')
                self.num_downs = 0
                return True
            else:
                print('Received 1st DOWN spell.')
                return False

        else:
            return False

         
        
if __name__ == "__main__":
    
    BP = brickpi3.BrickPi3() # Create an instance of the BrickPi3 class. BP will be the BrickPi3 object.

    try:
        BP.offset_motor_encoder(BP.PORT_A, BP.get_motor_encoder(BP.PORT_A)) # reset encoder A
    except IOError as error:
        print(error)

    BP.set_motor_limits(BP.PORT_A, 99, 400)          # optionally set a power limit (in percent) and a speed limit (in Degrees Per Second)
    
    ctrl = MotorController(BP)

    ip = '127.0.0.1'  # pi ip: 192.168.195.28
    port = '12001'
    
    # Parse arguments for host ip and port.
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip",
        default=ip, help="The ip to listen on")
    parser.add_argument("--port",
        type=int, default=port, help="The port to listen on")
    args = parser.parse_args()
    
    # Create dispatcher to handle incoming OSC messages.
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/elevator/up", ctrl.call_up)
    dispatcher.map("/elevator/down", ctrl.call_down)
    
    server = osc_server.ThreadingOSCUDPServer(
            (args.ip, args.port), dispatcher)
        
    print("Serving on {}".format(server.server_address))
    server.serve_forever()


