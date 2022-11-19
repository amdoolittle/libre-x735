#!/bin/bash

svcloc=/etc/systemd/system/pwmfan.service

sed -e 's,scriptpath,'"$(pwd)"',g' pwmfan.service > $svcloc

systemctl daemon-reload
systemctl enable pwmfan.service
