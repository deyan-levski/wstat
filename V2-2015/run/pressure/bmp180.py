#!/usr/bin/python
#--------------------------------------
#    ___  ___  _ ____          
#   / _ \/ _ \(_) __/__  __ __ 
#  / , _/ ___/ /\ \/ _ \/ // / 
# /_/|_/_/  /_/___/ .__/\_, /  
#                /_/   /___/   
#
#           bmp180.py
#  Read data from a digital pressure sensor.
#
# Author : Matt Hawkins
# Date   : 15/04/2015
#
# http://www.raspberrypi-spy.co.uk/
#
#--------------------------------------
#import smbus
import time
from ctypes import c_short
import csv

from pyA20 import i2c

# Default device I2C address
DEVICE = 0x77

def convertToString(data):
  # Simple function to convert binary data into
  # a string
  return str((data[1] + (256 * data[0])) / 1.2)

def getShort(data, index):
  # return two bytes from data as a signed 16-bit value
  return c_short((data[index] << 8) + data[index + 1]).value

def getUshort(data, index):
  # return two bytes from data as an unsigned 16-bit value
  return (data[index] << 8) + data[index + 1]

def readBmp180Id(addr=DEVICE):
  #Slave Device adress
  i2c.open(addr)

  # Register Address
  REG_ID=0xD0

  #Set address at 0xD0 register
  i2c.write( [REG_ID] )
  ( chip_id, chip_version ) = i2c.read(2)

  i2c.close()
  return (chip_id, chip_version)

def readBmp180(addr=DEVICE):
  #Slave Device adress
  i2c.open(addr)

  # Register Addresses
  REG_CALIB  = 0xAA
  REG_MEAS   = 0xF4
  REG_MSB    = 0xF6
  REG_LSB    = 0xF7

  # Control Register Address
  CRV_TEMP   = 0x2E
  CRV_PRES   = 0x34

  # Oversample setting
  OVERSAMPLE = 0   # 0 - 3

  # Read calibration data
  # Read calibration data from EEPROM
  i2c.write([REG_CALIB])
  cal = i2c.read(22)

  # Convert byte data to word values
  AC1 = getShort(cal, 0)
  AC2 = getShort(cal, 2)
  AC3 = getShort(cal, 4)
  AC4 = getUshort(cal, 6)
  AC5 = getUshort(cal, 8)
  AC6 = getUshort(cal, 10)
  B1  = getShort(cal, 12)
  B2  = getShort(cal, 14)
  MB  = getShort(cal, 16)
  MC  = getShort(cal, 18)
  MD  = getShort(cal, 20)

  print("AC1:",AC1)
  print("AC2:",AC2)
  print("AC3:",AC3)
  print("AC4:",AC4)
  print("AC5:",AC5)
  print("AC6:",AC6)
  print("B1:",B1)
  print("B2:",B2)
  print("MB:",MB)
  print("MC:",MC)
  print("MD",MD)

  # Read temperature
  i2c.write( [REG_MEAS, CRV_TEMP] )
  time.sleep(0.015)

  i2c.write([0xF6])
  ( msb, lsb ) = i2c.read( 2 )

  UT = (msb << 8) + lsb
  print("msb,lsb",msb,lsb)
  print("UT",UT)

  # Read pressure
  i2c.write([REG_MEAS, CRV_PRES + (OVERSAMPLE << 6)])
  time.sleep(0.14)
  i2c.write([REG_MSB])
  (msb, lsb, xsb) = i2c.read(3)
  i2c.close()
  print("msb,lsb,xsb",msb,lsb,xsb)
  UP = ((msb << 16) + (lsb << 8) + xsb) >> (8 - OVERSAMPLE)
  print("UP",UP)

  # Refine temperature
  X1 = ((UT - AC6) * AC5) >> 15
  X2 = (MC << 11) / (X1 + MD)
  B5 = X1 + X2
  temperature = ( B5 + 8 ) >> 4

  # Refine pressure
  B6  = B5 - 4000
  B62 = B6 * B6 >> 12
  X1  = (B2 * B62) >> 11
  X2  = AC2 * B6 >> 11
  X3  = X1 + X2
  B3  = (((AC1 * 4 + X3) << OVERSAMPLE) + 2) >> 2

  X1 = AC3 * B6 >> 13
  X2 = (B1 * B62) >> 16
  X3 = ((X1 + X2) + 2) >> 2
  B4 = (AC4 * (X3 + 32768)) >> 15
  B7 = (UP - B3) * (50000 >> OVERSAMPLE)

  P = (B7 * 2) / B4

  X1 = ( P >> 8 ) * ( P >> 8 )
  X1 = ( X1 * 3038 ) >> 16
  X2 = ( -7357 * P ) >> 16
  pressure = P + ( (X1 + X2 + 3791) >> 4 )

  return ( temperature / 10.0, pressure/ 100.0 )

def main():
  i2c.init("/dev/i2c-1")

  (chip_id, chip_version) = readBmp180Id()

  print "Chip ID     :", chip_id
  print "Version     :", chip_version
  print

  ( temperature, pressure ) = readBmp180()

  print
  print "Temperature : ", temperature, "C"
  print "Pressure    : ", pressure, "mbar"
  print

  RESULTS = [
    [ "Temperature", "Pressure" ],
    [ temperature, pressure ]
  ]

  with open('some.csv', 'wb') as f:
    writer = csv.writer( f )
    writer.writerows( RESULTS )

if __name__ == "__main__":
   main()
