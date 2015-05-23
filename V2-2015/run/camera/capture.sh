#!/bin/sh

echo "Starting image capture"
fswebcam -d /dev/video0 -r 640x480 --title "Live weather conditions in Ruse, Bulgaria" --jpeg 100 ../www/img/conditions_lores.jpg
fswebcam -d /dev/video0 -r 1920x1080 --title "Live weather conditions in Ruse, Bulgaria" --jpeg 100 ../www/img/conditions_hires.jpg

