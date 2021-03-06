#!/usr/bin/env python
 
# Bit-Banged SPI for the MCP3008 ADC chip suited for Olimex's Olinuxino MICRO Allwinner A20 processor board
#
# Initial version P1A, Deyan Levski, deyan.levski@gmail.com, 25/07/2015
#
 
import time
import os

from pyA20.gpio import gpio
from pyA20.gpio import port
from pyA20.gpio import connector

gpio.init() 
 
DEBUG = 1
 
def readadc(adcnum, CLK, MOSI, MISO, CS):
        if ((adcnum > 7) or (adcnum < 0)):
                return -1
        gpio.output(CS, 1)
 
        gpio.output(CLK, 0)  # start clock low
        gpio.output(CS, 0)     # bring CS low
 
        commandout = adcnum
        commandout |= 0x18  # start bit + single-ended bit
        commandout <<= 3    # we only need to send 5 bits here
        for i in range(5):
                if (commandout & 0x80):
                        gpio.output(MOSI, 1)
                else:
                        gpio.output(MOSI, 0)
                commandout <<= 1
                gpio.output(CLK, 1)
                gpio.output(CLK, 0)
 
        adcout = 0

        for i in range(14):
                gpio.output(CLK, 1)
                gpio.output(CLK, 0)
                adcout <<= 1
                if (gpio.input(MISO)):
                        adcout |= 0x1
 
        gpio.output(CS, 1)
        
        adcout >>= 1       # first bit is 'null' so drop it
        return adcout

# set ports
SPICLK = port.PI17
SPIMISO = port.PI19
SPIMOSI = port.PI18
SPICS = port.PI16
 
# set pins I/O
gpio.setcfg(SPIMOSI, 1) #MOSI
gpio.setcfg(SPIMISO, 0) #MISO
gpio.setcfg(SPICLK, 1) #CLK
gpio.setcfg(SPICS, 1) #CS


ch0 = readadc(0, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch1 = readadc(1, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch2 = readadc(2, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch3 = readadc(3, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch4 = readadc(4, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch5 = readadc(5, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch6 = readadc(6, SPICLK, SPIMOSI, SPIMISO, SPICS)
ch7 = readadc(7, SPICLK, SPIMOSI, SPIMISO, SPICS)

print "CO-sens:", ch0
print "RH-sens:", ch1
print "Air-tmp:", ch2
print "Soil-tmp:", ch3
print "CH4:", ch4
print "CH5:", ch5
print "CH6:", ch6
print "CH7:", ch7
