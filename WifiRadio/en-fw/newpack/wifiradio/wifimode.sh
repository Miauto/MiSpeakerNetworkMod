#!/bin/sh

wifimode=$(uci get wifiradio.@setting[0].wifimode)

if [ $wifimode = 'hotspot' ]
then
    # client
    uci set wifiradio.@setting[0].wifimode="client"
    aplay -f cdr /usr/share/sound/wificlient.wav
    rm "/tmp/need_dhcp_flag" >/dev/null 2>&1
    killall hostapd  >/dev/null 2>&1
    /etc/init.d/wireless restart
    show_led 0
else
    # hotspot
    uci set wifiradio.@setting[0].wifimode="hotspot"
    aplay -f cdr /usr/share/sound/wifihotspot.wav
    /etc/init.d/wireless stop
    modprobe dhd
    touch "/tmp/need_dhcp_flag"
    echo -n /etc/wifi/fw_bcmdhd.bin > /sys/module/dhd/parameters/firmware_path
    echo -n /data/wifi/nvram.txt > /sys/module/dhd/parameters/nvram_path
    echo -n 2 >/sys/module/dhd/parameters/op_mode
    /etc/init.d/dhcpc stop
    /etc/init.d/dnsmasq restart
    ifconfig wlan0 up
    ifconfig wlan0 10.0.0.1
    bssid=`matool_get_mac`
    wl down
    wl cur_etheraddr  $bssid
    wl up
    ifconfig wlan0 10.0.0.1
    hostapd /etc/hostapd/hostapd.conf &
    show_led 5
fi
uci commit wifiradio
