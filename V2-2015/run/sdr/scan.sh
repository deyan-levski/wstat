#!/bin/sh

BASE="/home/deyan"

rtl_power -f 26M:1750M:125k -g 25 -e 20h $BASE/station/run/sdr/radiomap.csv

python $BASE/station/run/sdr/heatmap.py $BASE/station/run/sdr/radiomap.csv $BASE/station/www/img/radiomap.jpg

rm $BASE/station/run/sdr/radiomap.csv
