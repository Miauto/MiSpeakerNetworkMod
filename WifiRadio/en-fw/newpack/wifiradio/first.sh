#!/bin/sh  
# ©2019 WifiRadio.su
uci set wifiradio.@setting[0].current=2
uci commit wifiradio
/etc/wifiradio/play.sh
