#!/usr/bin/env bash

if [[ `$HOME/.config/i3/scripts/monitor_switch.sh -l | grep HDMI` == "# HDMI1	53414d53554e47	" ]]; then
  echo "one"
  xrandr --output HDMI1 --mode 1680x1050 --right-of eDP1
elif `$HOME/.config/i3/scripts/monitor_switch.sh -l | grep -q HDMI`; then
  echo "two"
  xrandr --output eDP1 --auto --output HDMI1 --auto  --left-of eDP1
else
  echo "three"
  xrandr --output eDP1 --auto --output HDMI1 --off
fi
echo `$HOME/.config/i3/scripts/monitor_switch.sh -l | grep HDMI`
