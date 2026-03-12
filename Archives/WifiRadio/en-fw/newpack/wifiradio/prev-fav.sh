#!/bin/sh  
# ©2019 WifiRadio.su 
source=$(uci get wifiradio.@setting[0].source)
if [ $source = 'speaker' ]
then
        exit 0
fi

fav=$(uci get wifiradio.@setting[0].fav)

if [ $fav -eq "00" ]
then
cur=$(uci get wifiradio.@fav[0].10)
uci set wifiradio.@setting[0].fav="10"	
fi

if [ $fav -eq "01" ]
then
cur=$(uci get wifiradio.@fav[0].00)
uci set wifiradio.@setting[0].fav="0"	
fi

if [ $fav -eq "02" ]
then
cur=$(uci get wifiradio.@fav[0].01)
uci set wifiradio.@setting[0].fav="1"	
fi

if [ $fav -eq "03" ]
then
cur=$(uci get wifiradio.@fav[0].02)
uci set wifiradio.@setting[0].fav="2"	
fi

if [ $fav -eq "04" ]
then
cur=$(uci get wifiradio.@fav[0].03)
uci set wifiradio.@setting[0].fav="3"	
fi

if [ $fav -eq "05" ]
then
cur=$(uci get wifiradio.@fav[0].04)
uci set wifiradio.@setting[0].fav="4"	
fi

if [ $fav -eq "06" ]
then
cur=$(uci get wifiradio.@fav[0].05)
uci set wifiradio.@setting[0].fav="5"	
fi

if [ $fav -eq "07" ]
then
cur=$(uci get wifiradio.@fav[0].06)
uci set wifiradio.@setting[0].fav="6"	
fi

if [ $fav -eq "08" ]
then
cur=$(uci get wifiradio.@fav[0].07)
uci set wifiradio.@setting[0].fav="7"	
fi

if [ $fav -eq "09" ]
then
cur=$(uci get wifiradio.@fav[0].08)
uci set wifiradio.@setting[0].fav="8"	
fi

if [ $fav -eq "10" ]
then
cur=$(uci get wifiradio.@fav[0].09)
uci set wifiradio.@setting[0].fav="9"	
fi
  
uci set wifiradio.@setting[0].current=$cur
uci set wifiradio.@setting[0].pfp=0
uci commit wifiradio

mpc stop
/etc/wifiradio/play.sh
