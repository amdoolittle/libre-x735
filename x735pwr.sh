#!/bin/bash
SHUTDOWN=497
REBOOTPULSE=200
SHUTDOWNPULSE=600

echo "$SHUTDOWN" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio$SHUTDOWN/direction
BOOT=496
echo "$BOOT" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$BOOT/direction
echo "1" > /sys/class/gpio/gpio$BOOT/value

echo "X735 Waiting for button press..."

while [[ 1 ]]; do
  shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
  if [[ $shutdownSignal -eq 0 ]]; then
    /bin/sleep 0.2
  else
    pulseStart=$(date +%s)
    while [[ $shutdownSignal -eq 1 ]]; do
      /bin/sleep 0.2
      if [[ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $SHUTDOWNPULSE ]]; then
        echo "X735 Shutting down..."
        sleep 1
        /usr/sbin/poweroff
        exit
      fi
      shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
    done
    if [[ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSE ]]; then
      echo "X735 Rebooting..."
      sleep 1
      /usr/sbin/reboot
      exit
    fi
  fi
done
