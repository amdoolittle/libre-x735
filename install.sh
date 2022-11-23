#!/bin/bash

svcloc=/etc/systemd/system

sed -e 's,scriptpath,'"$(pwd)"',g' x735fan.service > $svcloc/x735fan.service
sed -e 's,scriptpath,'"$(pwd)"',g' x735pwr.service > $svcloc/x735pwr.service

systemctl daemon-reload
systemctl enable x735fan.service
systemctl enable x735pwr.service
