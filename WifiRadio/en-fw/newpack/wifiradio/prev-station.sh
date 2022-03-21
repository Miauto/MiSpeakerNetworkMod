#!/bin/sh  
# ©2019 WifiRadio.su 
source=$(uci get wifiradio.@setting[0].source)
if [ $source = 'speaker' ]
then
        exit 0
fi

if [ $source = 'player' ]
then
        mpc prev
        exit 0
fi


cur=$(uci get wifiradio.@setting[0].current) 

maxnumb=$((0))
while read line
do
maxnumb=$(($maxnumb + 1))
done < /etc/wifiradio/playlist.m3u 

if [ $cur -ge 4 ]
        then  
                nx=$(($cur-2))
		else
				nx=$maxnumb
        fi 

uci set wifiradio.@setting[0].current=$nx
uci commit wifiradio

mpc stop
/etc/wifiradio/play.sh
