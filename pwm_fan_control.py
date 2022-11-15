#!/usr/bin/python3
from signal import *
import lgpio
import time

FAN_PIN = 85 # On RPi, GPIO 13 (what x735 uses for fan PWM) is physical pin 33, which maps to Le Potato logical pin 85 on chip 1
PWM_HZ = 10000 # Max HZ in lgpio library is 10K

h = lgpio.gpiochip_open(1)

def clean():
    lgpio.gpiochip_close(h)

signal(Signals.SIGTERM, clean)

while(1):
    last = 0
    # Get CPU temp
    file = open("/sys/class/thermal/thermal_zone0/temp")
    temp = float(file.read()) / 1000.00
    temp = float('%.2f' % temp)
    file.close()

    if(temp > 65):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 100)
    elif(temp > 60):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 90)
    elif(temp > 55):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 75)
    elif(temp > 50):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 50)
    elif(temp > 30):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 40)
    elif(temp <= 30):
         lgpio.tx_pwm(h, FAN_PIN, PWM_HZ, 0)
    time.sleep(10)
