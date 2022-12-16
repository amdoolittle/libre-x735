#!/bin/bash
REBOOTPULSEMIN=200
# 1.3 seconds plus potential 0.2 second sleep time for 1.5 max restart
REBOOTPULSEMAX=1300 

SHUTDOWN=497
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
    pulseStart=$(date +%s%N | cut -b1-13)
    while [[ $shutdownSignal -eq 1 ]]; do
      /bin/sleep 0.2
      if [[ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAX ]]; then
        echo "X735 Shutting down"
	/bin/sleep 1
        # Disable watchdog and halt
        echo 'V' | tee /dev/watchdog
        /usr/sbin/shutdown -H now
        exit
      fi
      shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
    done
    if [[ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMIN ]]; then
      echo "X735 Rebooting"
      /bin/sleep 1
      /usr/sbin/reboot
      exit
    fi
  fi
done
