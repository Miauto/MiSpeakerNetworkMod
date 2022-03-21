#!/bin/sh  
# ©2019 WifiRadio.su

while (true) 
do

mac=`ifconfig wlan0 | head -1 | sed 's/ \+/ /g' | cut -d' ' -f5`
sleep 1
station=$(uci get wifiradio.@setting[0].station)
ver=$(uci get wifiradio.@setting[0].version_loc)
server=$(uci get wifiradio.@setting[0].server)
link=$(uci get wifiradio.@setting[0].station_url)
city=$(uci get wifiradio.@setting[0].city)
city=${city//-/}
curl -A "WifiRadio.SU" "$server/stat.php?ver=$ver.Xiaomi&station=$station&mac=$mac&city=$city&link=$link"

 sleep 900;
done;