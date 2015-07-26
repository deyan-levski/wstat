#!/usr/bin/env python
"""Read wind vane output and determine wind direction

Version P1A , Deyan Levski, deyan.levski@gmail.com, 25/07/2015

"""

import os
import sys

if not os.getegid() == 0:
    sys.exit('Script must be run as root')


from pyA20.gpio import gpio
from pyA20.gpio import connector
from pyA20.gpio import port

#led = connector.gpio0p0     # This is the same as port.PH2
#button = connector.gpio3p40

N =  
S =
E = 
W =
NW = 
NE = 
SW = 
SE = 

"""Init gpio module"""
gpio.init()

"""Set directions"""
gpio.setcfg(led, gpio.OUTPUT)
gpio.setcfg(button, gpio.INPUT)

"""Enable pullup resistor"""
gpio.pullup(button, gpio.PULLUP)
#gpio.pullup(button, gpio.PULLDOWN)     # Optionally you can use pull-down resistor

try:
    print ("Press CTRL+C to exit")
    while True:
        state = gpio.input(button)      # Read button state

        """Since we use pull-up the logic will be inverted"""
        gpio.output(led, not state)

except KeyboardInterrupt:
    print ("Goodbye.")

