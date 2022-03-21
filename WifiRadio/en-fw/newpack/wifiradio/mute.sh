#!/bin/sh  
# ©2019 WifiRadio.su

mute=$(uci get wifiradio.@setting[0].mute)

if [ $mute -eq 0 ]
then
uci set wifiradio.@setting[0].mute=1
uci commit wifiradio

sound=$(uci get wifiradio.@setting[0].sound)
lastvol=$(echo `amixer get $sound | grep 'Front Left: Playback' | awk '{ print $5 }' | grep -Eo '[0-9]+'`)
uci set wifiradio.@setting[0].lastvol=$lastvol
uci commit wifiradio
amixer -c 0 -- sset $sound Playback Volume 0%
fi

