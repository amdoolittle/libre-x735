#!/bin/bash

BUTTON=483
# Default to 3 second pull-up (shutdown time window)
SLEEP=${1:-3}
re='^[0-9\.]+$'

if [[ ! $SLEEP =~ $re ]]; then
  echo "error: sleep time not a number" >&2; exit 1
fi

echo "X735 shutting down"

echo "$BUTTON" > /sys/class/gpio/export;
echo "out" > /sys/class/gpio/gpio$BUTTON/direction
echo "1" > /sys/class/gpio/gpio$BUTTON/value
/bin/sleep $SLEEP
echo "0" > /sys/class/gpio/gpio$BUTTON/value
