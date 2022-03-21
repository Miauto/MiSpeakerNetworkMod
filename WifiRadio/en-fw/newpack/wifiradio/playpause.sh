#!/bin/sh
# ©2019 WifiRadio.su

source=$(uci get wifiradio.@setting[0].source)
if [ $source = 'speaker' ]
then
        exit 0
fi

playpause=$(uci get wifiradio.@setting[0].playpause)

if [[ $playpause == "play" ]]
then
uci set wifiradio.@setting[0].playpause=stop
uci commit wifiradio  
/etc/wifiradio/play.sh
fi

if [[ $playpause == "stop" ]]
then
uci set wifiradio.@setting[0].playpause=play
uci commit wifiradio 
/etc/wifiradio/stop.sh
fi
