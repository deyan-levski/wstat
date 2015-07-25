#!/usr/bin/env python

from pyA20 import i2c


"""Initialize i2c bus"""
i2c.init("/dev/i2c-2")

i2c.open(0x77) #Slave Device adress

"""Set address pointer to the first"""
i2c.write([0x00])

print "Dump eeprom:"

i2c.close()
