#!/bin/sh

BASE="/home/wstat/wstat"

rtl_power -f 26M:1750M:125k -g 25 -e 20h $BASE/V2-2015/run/sdr/radiomap.csv

python $BASE/V2-2015/run/sdr/heatmap.py $BASE/V2-2015/run/sdr/radiomap.csv $BASE/V2-2015/www/img/radiomap.jpg

rm $BASE/V2-2015/run/sdr/radiomap.csv
