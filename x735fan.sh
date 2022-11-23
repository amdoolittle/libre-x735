#!/bin/bash
# Author: Alex Doolittle
# Version: 1.0
# Description:
#   This shell script is meant to run as a "simple" systemd service or background task
#   and will continuously check the temperature every $delay seconds. The PWM duty cycle
#   will be adjusted based on the temperature, and if changed since the last check, the
#   PWM generator will be udpated with the new duty cycle.
#
# Changelog:
#   V1.0 - 2022 Nov 17, Initial commit
#
# Notes:
# - Device tree overlay for PWM must be enabled using the libretech-wiring-tool
#
#   git clone https://github.com/libre-computer-project/libretech-wiring-tool.git
#   cd libretech-wiring-tool
#   make
#   sudo ./ldto enable pwm-a
#   sudo ./ldto merge pwm-a

# PWM frequency in Hz
freq=25000
# Wait time between temperature checks
delay=10

# Period is nanoseconds per cycle
period=$((1 * 1000000000 / freq))
# Track previous duty cycle to avoid excessive calls
last_cycle=0

# Overlay paths for pwmchip and specific pwm output
chip_path="/sys/class/pwm/pwmchip0"
pwm_path="$chip_path/pwm0"

# Only export if not already exported
if [[ ! -d $pwm_path ]]; then
  echo "Exporting PWM0"
  # Export pwm0 for use
  echo 0 > $chip_path/export
  sleep 1
fi

# Set period based on desired frequency
echo $period > $pwm_path/period
sleep 1

# Only enable if not already enabled
if [[ $(cat $pwm_path/enable) -eq 0 ]]; then
  echo "Enabling PWM0"
  echo 1 > $pwm_path/enable
fi

echo "Beginning temperature-based fan control..."
while [[ 1 ]]; do
  # Get temperature (celsuis * 1000)
  temp=$(cat /sys/class/thermal/thermal_zone0/temp)

  if [[ $temp -ge 65000 ]]; then
    duty_cycle=100
  elif [[ $temp -gt 60000 ]]; then
    duty_cycle=90
  elif [[ $temp -gt 55000 ]]; then
    duty_cycle=75
  elif [[ $temp -gt 45000 ]]; then
    duty_cycle=50
  elif [[ $temp -gt 30000 ]]; then
    duty_cycle=40
  else
    duty_cycle=0
  fi

  # If the duty cycle has changed from the last run, update the PWM generator
  if [[ $duty_cycle -ne $last_cycle ]]; then
    echo "Temperature is $((temp / 1000)) celsius, new duty cycle is $duty_cycle%"
    echo $((period * duty_cycle / 100)) > $pwm_path/duty_cycle
    # Track the new duty cycle as last value
    last_cycle=$duty_cycle
  fi

  # Wait to check again, this doesn't need to be constant
  sleep $delay
done
