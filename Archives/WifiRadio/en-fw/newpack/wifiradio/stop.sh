#!/bin/sh
# ©2019 WifiRadio.su
mpc stop
uci set wifiradio.@setting[0].playpause=play
uci commit wifiradio

