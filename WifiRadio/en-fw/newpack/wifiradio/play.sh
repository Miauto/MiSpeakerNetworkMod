#!/bin/sh  
# ©2019 WifiRadio.su 
source=$(uci get wifiradio.@setting[0].source)

if [ $source = 'speaker' ]
then
	exit 0
fi

if [ $source = 'player' ]
then
	mpc toggle
	exit 0
fi

uci set wifiradio.@setting[0].playpause=stop
uci commit wifiradio

ver=$(uci get wifiradio.@setting[0].version_loc)
server=$(uci get wifiradio.@setting[0].server)
mac=`ifconfig wlan0 | head -1 | sed 's/ \+/ /g' | cut -d' ' -f5`
sound=$(uci get wifiradio.@setting[0].sound)
voice=$(uci get wifiradio.@setting[0].voice)
cur=$(uci get wifiradio.@setting[0].current)
tts=$(uci get wifiradio.@setting[0].tts)
city=$(uci get wifiradio.@setting[0].city)
city=${city//-/}
 
cur_url=$(($cur))
url=`cat /etc/wifiradio/playlist.m3u | sed -n ${cur_url}p`

cur=$(($cur-1))
name=`cat /etc/wifiradio/playlist.m3u | sed -n ${cur}p`
name=${name//#EXTINF:-1,/}

name=${name// /_}
link=$url

uci set wifiradio.@setting[0].station="$name"
uci set wifiradio.@setting[0].station_url="$url"
uci commit wifiradio

mpc clear
mpc repeat on

if [ $voice -eq 1 ]
then

usr=$((0))
while read line
do
usr=$(($usr+1))
done < /etc/wifiradio/user.m3u

if [ $cur -le $usr ]
then
curl "$server/voice_.php?ver=$ver.Full&station=$name&tts=$tts&mac=$mac&city=$city&link=$link"
sleep 1
mpc add "$server/tts.voice/$tts.$name.mp3"
else
mpc add "$server/tts.voice/$tts.$name.mp3"
fi
fi

mpc add $url
mpc play 1
