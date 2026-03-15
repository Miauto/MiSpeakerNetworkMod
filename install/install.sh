#!/bin/sh
set -e

echo "[*] Install MiSpeakerNetworkMod"

mkdir -p /opt/audio-system/manager
mkdir -p /www/cgi-bin
mkdir -p /www/mispeaker

# binaires
cp bin/librespot_armv7_xiaomi /usr/local/bin/librespot
chmod +x /usr/local/bin/librespot

# manager
cp manager/audio_manager.sh /opt/audio-system/manager/audio_manager.sh
cp manager/auto_switch.sh /opt/audio-system/manager/auto_switch.sh
chmod +x /opt/audio-system/manager/audio_manager.sh
chmod +x /opt/audio-system/manager/auto_switch.sh
[ -f /opt/audio-system/manager/state.json ] || echo '{"source":"none"}' > /opt/audio-system/manager/state.json

# init.d
cp services/spotify/init.d/spotify /etc/init.d/spotify
cp services/bluetooth/init.d/bluetooth /etc/init.d/bluetooth
cp services/linein/init.d/linein /etc/init.d/linein
cp services/dlnainit/init.d/dlnainit /etc/init.d/dlnainit
cp services/autoswitch/init.d/autoswitch /etc/init.d/autoswitch
cp boot/init.d/mispeaker_boot /etc/init.d/mispeaker_boot

chmod +x /etc/init.d/spotify /etc/init.d/bluetooth /etc/init.d/linein \
          /etc/init.d/dlnainit /etc/init.d/autoswitch /etc/init.d/mispeaker_boot

# web (lighttpd)
cp webui/cgi-bin/mispeaker.sh /www/cgi-bin/mispeaker.sh
chmod +x /www/cgi-bin/mispeaker.sh
cp webui/index.html /www/mispeaker/index.html

# enable/disable
/etc/init.d/spotify enable
/etc/init.d/bluetooth enable
/etc/init.d/autoswitch enable
/etc/init.d/mispeaker_boot enable

/etc/init.d/linein disable
/etc/init.d/dlnainit disable

echo "[*] Done. Reboot or run:"
echo "  /etc/init.d/mispeaker_boot start"
echo "  /etc/init.d/autoswitch start"
