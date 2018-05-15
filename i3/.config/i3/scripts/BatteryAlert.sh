#!/bin/bash

BATTERY0=$(upower -e | grep 'BAT0')

##while [ 1 ]
##do
BATTERY_PERCENTAGE0=$(upower -i $BATTERY0|grep percentage|awk '{ print $2 }'|sed s/'%'/''/g)

BATTERY1=$(upower -e | grep 'BAT1')

##while [ 1 ]
##do
BATTERY_PERCENTAGE1=$(upower -i $BATTERY1|grep percentage|awk '{ print $2 }'|sed s/'%'/''/g)

echo $BATTERY_PERCENTAGE0% $BATTERY_PERCENTAGE1%
if [[ "$BATTERY_PERCENTAGE0" -lt "20" && "$BATTERY_PERCENTAGE1" -lt "20" ]]; then

echo "#FFAE00"
notify-send --urgency=critical --expire-time=5000 -i  "WARNING: Battery is about to die"  "Plug in the power cable"

fi

##sleep 10

##done
