#!/bin/sh
#
# Wind vane direction readout script
# 
# Version P1A, Deyan Levski, deyan.levski@gmail.com, 25/07/2015
#
#


# Set input ports
#

for i in `seq 1 1 5`; do echo $i > /sys/class/gpio/export; done

PORTN=gpio1_pb0
PORTS=gpio2_pe0
PORTE=gpio3_pb1
PORTW=gpio4_pe1
PORTNW=gpio5_pi0
PORTNE=gpio6_pe2
PORTSW=gpio7_pi1
PORTSE=gpio8_pe3

echo in > /sys/class/gpio/$PORTN/direction
echo in > /sys/class/gpio/$PORTS/direction
echo in > /sys/class/gpio/$PORTE/direction
echo in > /sys/class/gpio/$PORTW/direction
echo in > /sys/class/gpio/$PORTNW/direction
echo in > /sys/class/gpio/$PORTNE/direction
echo in > /sys/class/gpio/$PORTSW/direction
echo in > /sys/class/gpio/$PORTSE/direction

N= cat /sys/class/gpio/$PORTN/value 
S= cat /sys/class/gpio/$PORTS/value 
E= cat /sys/class/gpio/$PORTE/value 
W= cat /sys/class/gpio/$PORTW/value 
NW= cat /sys/class/gpio/$PORTNW/value 
NE= cat /sys/class/gpio/$PORTNE/value 
SW= cat /sys/class/gpio/$PORTSW/value 
SE= cat /sys/class/gpio/$PORTSE/value 

echo "N,S,E,W,NW,NE,SW,SE" > dirwind.csv
echo "$N,$S,$E,$W,$NW,$NE,$SW,$SE" >> dirwind.csv



