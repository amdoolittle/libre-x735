# libre-x735
Libre Computer + X735 V3.0 Module

The GeekWorm-provided X735 scripts are written with the Raspberry Pi in mind, but the X735 V3.0 module works great with the Libre Computer aml-s905x-cc ("Le Potato"). Unfortunately, while they are form compatible, under the hood things vary quite a bit between the two. 

Of critical importance is the default values for all the GPIO pins, as well as the GPIO pin numbering.  On the Raspberry Pi, GPIO 0 through 8 are connected internally to pull-up by default, while the rest are pull-down; on the S905, GPIO 0-18 are pull-up by default and the rest are pull-down. 

Libre Computer provides a great document in Google Sheets that maps all the physical pins of the aml-s905x-cc, and you can then cross-reference the same physical pins on the Pi from any number of sources to determine which physical pin on the new board maps to what logical GPIO pin on Pi.

# PWM Fan Control

I've rewritten the fan control for the X735 to make use of the S905 chipset and the Libre-provided dtoverlay, with particular attention to ensuring the PWM generator is hardware-based.

# Shutdown Script

After reading through Geekworm's wiki and experimenting with the board, the X735 V3.0 relies on the default state of pin 38 on the Raspberry Pi to be a 0 (pull down) as it is on the Broadcom chip.  Unfortunately, the S905 has a different set of default pull-up/down values for the GPIO pins, and pin 38 is by default a 1 (pull up).  In order to make the X735 shutdown script function properly, the S905 pin 38 must default to 0 by attaching it to ground via a 10K resistor (pull down), overriding the internal pull up and allowing the X735 to function as if the board were a Raspberry Pi.
