# libre-x735
Libre Computer + X735 V3.0 Module

The GeekWorm-provided X735 scripts are written with the Raspberry Pi in mind, but the X735 V3.0 module works great with the Libre Computer aml-s905x-cc ("Le Potato"). Unfortunately, while they are form compatible, under the hood things vary quite a bit between the two. 

I've rewritten the fan control for the X735 to make use of the S905 chipset, with particular attention to ensuring the PWM generator is hardware-based.

Future work includes correcting the power button handler script to function for shutdown/reboot.
