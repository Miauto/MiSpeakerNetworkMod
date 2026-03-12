#!/bin/sh  
# ©2018 WifiRadio.su
source=$(uci get wifiradio.@setting[0].source)
if [ $source = 'speaker' ]
then
        exit 0
fi

sound=$(uci get wifiradio.@setting[0].sound)
amixer -q set $sound 2%-
#aplay -f cdr /usr/share/sound/volume.wav

