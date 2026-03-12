#!/bin/sh  
# ©2019 WifiRadio.su, 2020 andr68rus
uci set wifiradio.@setting[0].modelock="1"
uci commit
/etc/init.d/triggerhappy start
start_delay=$(uci get wifiradio.@setting[0].start_delay)
sleep $start_delay
sleep 3
mpd
mpc stop
/etc/init.d/shairport-sync stop
/etc/init.d/dlnainit stop

mac=`ifconfig wlan0 | head -1 | sed 's/ \+/ /g' | cut -d' ' -f5`

#sleep 1

sound=$(uci get wifiradio.@setting[0].sound)
startvol=$(uci get wifiradio.@setting[0].startvol)
night_vol=$(uci get wifiradio.@setting[0].night_vol)
auto=$(uci get wifiradio.@setting[0].autoupdate)
server=$(uci get wifiradio.@setting[0].server)
sserver=$(uci get wifiradio.@setting[0].sserver)
time=$(uci get wifiradio.@setting[0].time)
wheater=$(uci get wifiradio.@setting[0].wheater)
station=$(uci get wifiradio.@setting[0].station)
ver=$(uci get wifiradio.@setting[0].version_loc)
hello=$(uci get wifiradio.@setting[0].hello)
station=$(uci get wifiradio.@setting[0].station)
station_url=$(uci get wifiradio.@setting[0].station_url)
tts=$(uci get wifiradio.@setting[0].tts)
city=$(uci get wifiradio.@setting[0].city)
bt_name=$(uci get wifiradio.@setting[0].bt_name)
bt_enable=$(uci get wifiradio.@setting[0].bt_enable)
bt_discoverable=$(uci get wifiradio.@setting[0].bt_discoverable)
bt_connectable=$(uci get wifiradio.@setting[0].bt_connectable)
start_mode=$(uci get wifiradio.@setting[0].start_mode)
night_from=$(uci get wifiradio.@setting[0].night_from)
night_to=$(uci get wifiradio.@setting[0].night_to)

version_ser=`curl $sserver/download/ver.php | cat`
sleep 1
if (echo "$version_ser" | grep -E -q "^-?[0-9]+$"); then
    uci set wifiradio.@setting[0].version_ser=$version_ser
fi

# Restore BT
if [ -z $bt_name ]; then
    uci set wifiradio.@setting[0].bt_name="MiSpeaker"
    bt_name="MiSpeaker"
fi
if [ -z $bt_enable ]; then
    uci set wifiradio.@setting[0].bt_enable="1"
    bt_enable="1"
fi
if [ -z $bt_discoverable ]; then
    uci set wifiradio.@setting[0].bt_discoverable="1"
    bt_discoverable="1"
fi
if [ -z $bt_connectable ]; then
    uci set wifiradio.@setting[0].bt_connectable="1"
    bt_connectable="1"
fi
uci commit wifiradio

jq .device.bd_name=\"$bt_name\" /data/bt/mibt_config.json > /data/bt/mibt_config_tmp.json
jq .device.connectable=\"$bt_connectable\" /data/bt/mibt_config_tmp.json > /data/bt/mibt_config.json
jq .device.discoverable=\"$bt_discoverable\" /data/bt/mibt_config.json > /data/bt/mibt_config_tmp.json
jq .device.enable=\"$bt_enable\" /data/bt/mibt_config_tmp.json > /data/bt/mibt_config.json
/etc/init.d/bluetooth stop

if [ -z $night_vol ]; then
    uci set wifiradio.@setting[0].night_vol="27"
    night_vol="27"
fi


# If it is night now, set volume to night_vol
export TZ=`cat /etc/TZ`
TIME=`date +%H`
echo "$TIME"
if [ $TIME -gt $night_from ] || [ $TIME -lt $night_to ]; then
        amixer -c 0 -- sset $sound Playback Volume $night_vol%
else
	amixer -c 0 -- sset $sound Playback Volume $startvol%
fi

if ! ping -q -c 2 -W 6 google.com > /dev/null; then
    aplay -f cdr /usr/share/sound/no_wifi_player.wav
    start_mode="player"
else

    if [ $auto -eq 1 ]; then
	curl -o "/etc/wifiradio/playlists/playlists.tar.gz" $server/download/playlists_ru.tar.gz
	tar -xzf "/etc/wifiradio/playlists/playlists.tar.gz" -C "/etc/wifiradio/playlists/"
	rm -r -f "/etc/wifiradio/playlists/playlists.tar.gz"
	/www/cgi-bin/wr_split
    fi
    mpc clear
    mpc repeat off
    mpc random off

    mpc add $server/tts.work/start.mp3

    loca=$(uci get wifiradio.@setting[0].version_loc)
    ser=$(uci get wifiradio.@setting[0].version_ser)

    hello=${hello// /_}
    if [ $hello != "-" ]; then
        curl "$server/hello.php?hello=$hello&tts=$tts&mac=$mac"
        sleep 1
	mpc add "$server/tts.hello/"$mac"_hello.mp3"
    fi

    if [ $ser -gt $loca ]; then
	mpc add $server/tts.work/$tts.update.mp3
    fi

    if [ $time -eq 1 ]; then
	utcz=`cat /etc/TZ`
	len=`expr length $utcz`
	utcz=`expr substr $utcz $len 1`
	curl "$server/time.php?utcz=$utcz&tts=$tts&mac=$mac"
	mpc add "$server/tts.wtime/"$mac"_time.mp3"
    fi

    if [ $wheater -eq 1 ]; then
	city=${city//-/}
	curl "$server/wheater.php?city=$city&mac=$mac&tts=$tts"
	mpc add "$server/tts.wtime/"$mac"_wheater.mp3"
    fi

    mpc play 1

    #sleep 27
    mpc | grep playing
    while [ $? -eq 0 ]
    do
	    sleep 2
	    mpc | grep playing
    done

    mpc stop
fi


if [ "$start_mode" == "radio" ]; then
    aplay -f cdr /usr/share/sound/radio_mode.wav
    uci set wifiradio.@setting[0].fav="0"
    uci set wifiradio.@setting[0].mute="0"
    uci set wifiradio.@setting[0].source="radio"
    uci commit wifiradio
    uci commit
    /etc/init.d/touchpad stop
    /etc/init.d/dlnainit stop
    /etc/init.d/shairport-sync stop
    ubus -t 1 call mibt play '{"action":"stop"}'
    /etc/init.d/bluetooth stop
    /etc/init.d/shairport-sync stop
    /etc/init.d/upmpdcli stop
    /etc/wifiradio/play.sh
elif [ "$start_mode" == "speaker" ]; then
    aplay -f cdr /usr/share/sound/speaker_mode.wav
    uci set wifiradio.@setting[0].source="speaker"
    uci commit
    /etc/init.d/bluetooth start
    /etc/init.d/touchpad start
    /etc/init.d/shairport-sync start
    /etc/init.d/upmpdcli start
elif [ "$start_mode" == "player" ]; then
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

sleep 1
/etc/wifiradio/ping.sh $1 &
sleep 1
/etc/wifiradio/stt.sh $1 &
