#!/bin/bash

while true; do
  gosu user:user x11vnc -passwd $VNC_PASSWORD --rfbport 5900 -display $DISPLAY -N -forever
  sleep 1;
done
