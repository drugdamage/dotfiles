#!/bin/bash
# Kill any running waybar instance, then relaunch
pkill -x waybar
sleep 0.1
waybar &
