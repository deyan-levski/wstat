#!/bin/sh

rtl_power -f 26M:1750M:125k -g 25 -e 20h radiomap.csv

./heatmap.py radiomap.csv ../../www/img/radiomap.jpg

rm radiomap.csv
