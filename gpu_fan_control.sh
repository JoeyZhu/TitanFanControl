#!/bin/bash

#current_temp=$((`nvidia-smi -q -d TEMPERATURE | sed -n -e '/Current/s/.*\(.[0-9][0-9].\).*/\1/p'`))
#let speed=263*$current_temp**2/10000-211*$current_temp/100+97
#echo "Temperature is $current_temp%"
#echo "Setting fan to $speed%"


tempa=`/usr/bin/nvidia-smi dmon -s p -c 1 -i 0| tail -1`
tempb=`nvidia-smi dmon -s p -c 1 -i 1| tail -1`
echo "$tempa"


array=(`echo $tempa | tr ' ' ' '` )  

temp1=$array[2]
echo "GPU 1 temp is $temp1%"
echo "GPU 2 temp is $temp2%"
