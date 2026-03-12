#!/bin/sh
# ©2019 WifiRadio.su 
source=$(uci get wifiradio.@setting[0].source)
if [ $source = 'speaker' ]
then
        exit 0
fi

if [ $source = 'player' ]
then
	mpc next
        exit 0
fi



cur=$(uci get wifiradio.@setting[0].current)  

maxnumb=$((0))
while read line
do
maxnumb=$(($maxnumb + 1))
done < /etc/wifiradio/playlist.m3u 

if [ $cur -ge $maxnumb ]  
        then  
                nx=2  
		else

				nx=$(($cur+2)) 
         
        fi 
		
uci set wifiradio.@setting[0].current=$nx
uci commit wifiradio

mpc stop
/etc/wifiradio/play.sh
