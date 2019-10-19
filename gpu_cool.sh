#!/bin/bash

headless=true

if [ "$headless" = true ] ; then
    export DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0
fi
nvidia-settings -a "GPUFanControlState=1"
#nvidia-settings -a "[gpu:0]/GPUFanControlState=1"
#nvidia-settings -a "[gpu:1]/GPUFanControlState=1"

verbose=true


while true
do

    #gpu index
    i=0

    #Get GPU temperature of all cards
    for gputemp in $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader);do
    
    if [ "$verbose" = true ] ; then
        echo "gpu ${i} temp ${gputemp}"; 
    fi

        #Note: you need to set the minimum fan speed to a non-zero value, or it won't work
        #This fan profile is being used in my GTX580 (Fermi). Change it as necessary
	let speed=210*$gputemp**2/10000-100*$gputemp/100+30
        if [ "$speed" -gt "100" ]; then
            speed=100
        else
            if [ "$speed" -lt "20" ]; then
                speed=20
            fi
        fi
        #If temperature is between X to Y degrees, set fanspeed to Z value
        case "${gputemp}" in
                0[0-9])
                        newfanspeed="20"
                        ;;
                1[0-9])
                        newfanspeed="20"
                        ;;
                2[0-9])
                        newfanspeed="20"
                        ;;
                3[0-9])
                        newfanspeed="25"
                        ;;
                4[0-9])
                        newfanspeed="30"
                        ;;
                5[0-4])
                        newfanspeed="40"
                        ;;
                5[5-6])
                        newfanspeed="45"
                        ;;
                5[7-9])
                        newfanspeed="50"
                        ;;
                6[0-5])
                        newfanspeed="60"
                        ;;
                6[6-7])
                        newfanspeed="65"
                        ;;
                6[8-9])
                        newfanspeed="70"
                        ;;
                7[0-5])
                        newfanspeed="75"
                        ;;
                7[6-9])
                        newfanspeed="80"
                        ;;
                8[0-5])
                        newfanspeed="85"
                        ;;
                8[6-9])
                        newfanspeed="90"
                        ;;
                *)
                        newfanspeed="100"
                        ;;
        esac
        
        nvidia-settings -a "[fan-${i}]/GPUTargetFanSpeed=${speed}" 2>&1 >/dev/null
        #echo "gpu ${i} auto speed ${speed}"; 
        if [ "$verbose" = true ] ; then
            echo "gpu ${i} new fanspeed ${newfanspeed}, auto speed ${speed}"; 
        fi
        
        sleep 1s
    #increment gpu index
    i=$(($i+1))
    
    done
    sleep 5s
done
