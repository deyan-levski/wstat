#!/usr/bin/env python
 
# Written by Limor "Ladyada" Fried for Adafruit Industries, (c) 2015
# This code is released into the public domain
 
import time
import os
#import RPi.GPIO as GPIO

from pyA20.gpio import gpio
from pyA20.gpio import port
from pyA20.gpio import connector

gpio.init() 
 
#GPIO.setmode(GPIO.BCM)
DEBUG = 1
 
# read SPI data from MCP3008 chip, 8 possible adc's (0 thru 7)
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
        # read in one empty bit, one null bit and 10 ADC bits
        for i in range(14):
                gpio.output(CLK, 1)
                gpio.output(CLK, 0)
                adcout <<= 1
                if (gpio.input(MISO)):
                        adcout |= 0x1
 
        gpio.output(CS, 1)
        
        adcout >>= 1       # first bit is 'null' so drop it
        return adcout
 
# change these as desired - they're the pins connected from the
# SPI port on the ADC to the Cobbler
SPICLK = port.PI17
SPIMISO = port.PI19
SPIMOSI = port.PI18
SPICS = port.PI16
 
# set up the SPI interface pins
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

print "CH0:", ch0
print "CH1:", ch1
print "CH2:", ch2
print "CH3:", ch3
print "CH3:", ch3
print "CH4:", ch4
print "CH5:", ch5
print "CH6:", ch6
print "CH7:", ch7







#GPIO.setup(SPIMOSI, GPIO.OUT)
#GPIO.setup(SPIMISO, GPIO.IN)
#GPIO.setup(SPICLK, GPIO.OUT)
#GPIO.setup(SPICS, GPIO.OUT)
 
# 10k trim pot connected to adc #0
#potentiometer_adc = 1;
 
#last_read = 0       # this keeps track of the last potentiometer value
#tolerance = 5       # to keep from being jittery we'll only change
                    # volume when the pot has moved more than 5 'counts'
# 
#while True:
#	# we'll assume that the pot didn't move
#	trim_pot_changed = False
# 
#	# read the analog pin
#	trim_pot = readadc(potentiometer_adc, SPICLK, SPIMOSI, SPIMISO, SPICS)
#	# how much has it changed since the last read?
#	pot_adjust = abs(trim_pot - last_read)
# 
#	if DEBUG:
#		print "trim_pot:", trim_pot
#		print "pot_adjust:", pot_adjust
#		print "last_read", last_read
# 
#	if ( pot_adjust > tolerance ):
#	       trim_pot_changed = True
# 
#	if DEBUG:
#		print "trim_pot_changed", trim_pot_changed
# 
#	if ( trim_pot_changed ):
#		set_volume = trim_pot / 10.24           # convert 10bit adc0 (0-1024) trim pot read into 0-100 volume level
#		set_volume = round(set_volume)          # round out decimal value
#		set_volume = int(set_volume)            # cast volume as integer
# 
#		print 'Volume = {volume}%' .format(volume = set_volume)
#		set_vol_cmd = 'sudo amixer cset numid=1 -- {volume}% > /dev/null' .format(volume = set_volume)
#		os.system(set_vol_cmd)  # set volume
# 
#		if DEBUG:
#			print "set_volume", set_volume
#			print "tri_pot_changed", set_volume
# 
#		# save the potentiometer reading for the next loop
#		last_read = trim_pot
# 
#	# hang out and do nothing for a half second
#	time.sleep(2)
