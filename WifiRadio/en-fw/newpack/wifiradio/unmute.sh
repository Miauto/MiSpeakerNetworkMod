#!/bin/sh  
# ©2019 WifiRadio.su

uci set wifiradio.@setting[0].mute=0
uci commit wifiradio

sound=$(uci get wifiradio.@setting[0].sound)
lastvol=$(uci get wifiradio.@setting[0].lastvol)
amixer -c 0 -- sset $sound Playback Volume $lastvol%