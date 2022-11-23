# libre-x735
Libre Computer + X735 V3.0 Module

The GeekWorm-provided X735 scripts are written with the Raspberry Pi in mind, but the X735 V3.0 module works great with the Libre Computer aml-s905x-cc ("Le Potato"). Unfortunately, while they are form compatible, under the hood things vary quite a bit between the two. 

I've rewritten the fan control for the X735 to make use of the S905 chipset, with particular attention to ensuring the PWM generator is hardware-based.

# Shutdown Script

After reading through Geekworm's wiki and experimenting with the board, the X735 V3.0 relies on the default state of pin 38 on the Raspberry Pi, which is a 0 value (pull-down).  Unfortunately, the S905 chip has a different set of default pull-up/down values for the GPIO pins, and pin 38 is by default a 1 value (pull-up).  In order to make the X735 shutdown script function properly, the X735 must be set to default pin 38 to pull-down by attaching it to ground via a 10K resistor, overriding the internal pull-up and allowing the X735 to function as if the board were a Raspberry Pi.

