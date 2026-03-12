#!/bin/sh

source=$(uci get wifiradio.@setting[0].source)
modelock=$(uci get wifiradio.@setting[0].modelock)

if [ -z $modelock ]; then
    uci set wifiradio.@setting[0].modelock="0"
    modelock="1"
fi

if [ $modelock = '1' ]; then
    exit 0
fi

uci set wifiradio.@setting[0].modelock="1"
uci commit
modelock=1

if [ $source = 'radio' ];
then
	mpc stop
	aplay -f cdr /usr/share/sound/speaker_mode.wav
	uci set wifiradio.@setting[0].source="speaker"
	uci commit
	/etc/init.d/bluetooth start
	/etc/init.d/touchpad start
        /etc/init.d/shairport-sync start
        /etc/init.d/upmpdcli start
elif [ $source = 'player' ];
then
	uci set wifiradio.@setting[0].source="radio"
	uci set wifiradio.@player[0].lastsong=$(mpc | sed -n 's:.*#\(.*\)/.*:\1:p' | awk -F'/' '{print $1}')
	uci commit
	mpc stop
	mpc -w rm player
	mpc -w save player
	/etc/init.d/touchpad stop
	/etc/init.d/dlnainit stop
	/etc/init.d/shairport-sync stop
	ubus -t 1 call mibt play '{"action":"stop"}'
	/etc/init.d/bluetooth stop
	/etc/init.d/shairport-sync stop
	/etc/init.d/upmpdcli stop
	aplay -f cdr /usr/share/sound/radio_mode.wav
	sleep 1
	playpause=$(uci get wifiradio.@setting[0].playpause)
	if [[ $playpause == "stop" ]]
	then
		/etc/wifiradio/play.sh
	fi
elif [ $source = 'speaker' ];
then
	mpc stop
	ubus -t 1 call mibt play '{"action":"stop"}'
	/etc/init.d/bluetooth stop
	/etc/init.d/shairport-sync stop
	/etc/init.d/upmpdcli stop
	/etc/init.d/touchpad stop
	/etc/init.d/dlnainit stop
	aplay -f cdr /usr/share/sound/player_mode.wav
	mpc repeat $(uci get wifiradio.@player[0].repeat)
	mpc random $(uci get wifiradio.@player[0].random)
	mpc single off
	mpc clear
	mpc load player
	sleep 1
	if [ $(uci get wifiradio.@player[0].startlast) -eq 1 ]; then
	    mpc play $(uci get wifiradio.@player[0].lastsong)
	else
	    mpc play
	fi
	uci set wifiradio.@setting[0].source="player"
	uci commit
fi
uci set wifiradio.@setting[0].modelock="0"
uci commit
