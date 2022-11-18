# libre-x735
Libre Computer + X735 Module

The GeekWorm-provided X735 scripts are written with the Raspberry Pi in mind, but the X735 module works great with the Libretech Le Potato SBC. Unfortunately, while they are form compatible, under the hood things vary quite a bit between the two. 

I've rewritten the scripts for the x735 to make use of the S905 chipset, with particular attention to ensuring the PWM generator is hardware-based.

Installation is pretty simple:
