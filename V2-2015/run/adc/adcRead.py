#!/usr/bin/env python

import time
import os

from pyA20 import spi

#spi.open("/dev/spidev1.0")
#Open SPI device with default settings
# mode : 0
# speed : 100000kHz
# delay : 0
# bits-per-word: 8

#Different ways to open device
#spi.open("/dev/spidev2.0", mode=1)
#spi.open("/dev/spidev2.0", mode=2, delay=0)
#spi.open("/dev/spidev2.0", mode=3, delay=0, bits_per_word=8)
spi.open("/dev/spidev1.0", mode=0, delay=0, bits_per_word=8, speed=100000)

#spi.write([0x01, 0x02]) #Write 2 bytes to slave device
#spi.read(2) #Read 2 bytes from slave device
#spi.xfer([0x01, 0x02], 2) #Write 2 byte and then read 2 bytes.

#def ReadChannel(channel):
#	adc = spi.xfer([1,(8+channel)<<4,0],2)
#	#data = ((adc[1]&3) << 8) + adc[2]
#	data = adc[2]
#	return data

def ReadChannel(channel):
	adc = spi.xfer([0x01,0x90,0x00],3)
	data = adc
	return data


# Define sensor channels
light_channel = 1
temp_channel  = 1
 
# Define delay between readings
delay = 5
 
while True:
 
  # Read the light sensor data
  light_level = ReadChannel(light_channel)
  #light_volts = ConvertVolts(light_level,2)
 
  # Read the temperature sensor data
  #temp_level = ReadChannel(temp_channel)
  #temp_volts = ConvertVolts(temp_level,2)
  #temp       = ConvertTemp(temp_level,2)
 
  # Print out results
  print "--------------------------------------------"
  print("ADCDATA: {}".format(light_level))
 
  # Wait before repeating loop
  time.sleep(delay)


spi.close() #Close SPI bus
