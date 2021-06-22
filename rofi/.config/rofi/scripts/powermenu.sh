#!/bin/bash

rofi_command="rofi -theme themes/powermenu.rasi"

### Options ###
power_off=""
reboot=""
lock=""
suspend="鈴"
log_out=""
# Variable passed to rofi
options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $power_off)
        poweroff
        ;;
    $reboot)
        reboot
        ;;
    $lock)
        betterlockscreen --lock
        ;;
    $suspend)
        playerctl pause
        betterlockscreen -s
        ;;
    $log_out)
        i3-msg exit
        ;;
esac

