#!/bin/sh
# ©2019 WifiRadio.su
png=$(uci get wifiradio.@setting[0].ping)

if [ $png -eq 1 ]
then
while true; do
sleep 1
if ! ping -q -c 2 -W 6 google.com > /dev/null; then
ifdown wan
sleep 5
mpc stop

cur=$(uci get wifiradio.@setting[0].current) 

station=$cur

mpc stop
mpc play 2

fi
done
fi
