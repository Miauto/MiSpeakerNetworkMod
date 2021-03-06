#!/bin/sh

FOLDER="./newpack/"
# OpenSSH
opkg install "${FOLDER}"openssh-keygen_7.4p1-1_meson.ipk
opkg install "${FOLDER}"openssh-server_7.4p1-1_meson.ipk
opkg install "${FOLDER}"openssh-sftp-server_7.4p1-1_meson.ipk
/bin/cp -rf "${FOLDER}"sshd_config /etc/ssh/sshd_config
/etc/init.d/dropbear stop
/etc/init.d/dropbear disable
/etc/init.d/sshd enable
/etc/init.d/sshd start

# Shairport-sync
/bin/mv /etc/asound.conf /etc/asound-original.conf
opkg install "${FOLDER}"libpopt_1.7-5_meson.ipk
opkg install "${FOLDER}"shairport-sync_2.1.12_meson.ipk
/bin/cp -rf "${FOLDER}"config/shairport-sync /etc/config/shairport-sync
/bin/mv /etc/asound-original.conf /etc/asound.conf
/etc/init.d/shairport-sync enable
/etc/init.d/shairport-sync start

# Utils
opkg install "${FOLDER}"mc_4.8.13-1.2_meson.ipk
/bin/cp -rf "${FOLDER}"mc.charsets /etc/mc/
opkg install "${FOLDER}"nano_2.3.6-1_meson.ipk
/bin/cp -rf "${FOLDER}"profile /etc/profile
opkg install "${FOLDER}"jq_1.5-3_meson.ipk
opkg install "${FOLDER}"bash_4.2-5_meson.ipk
sed -i 's/\/bin\/ash/\/bin\/bash/' /etc/passwd
uniq /etc/shells > /tmp/shells
mv /tmp/shells /etc/shells

# MPD, MPC
opkg remove mpd-mini
opkg install "${FOLDER}"mpd-full_0.19.21-2_meson.ipk --nodeps
opkg install "${FOLDER}"mpc_0.26-2_meson.ipk
opkg install "${FOLDER}"libffmpeg-full_1.1.1-5_meson.ipk
/bin/cp -rf "${FOLDER}"mpd.conf /etc/mpd.conf
mkdir /root/.mpd
touch /root/.mpd/database
/bin/cp -rf "${FOLDER}"asound.conf /etc/asound.conf

# Triggerhappy
opkg install "${FOLDER}"triggerhappy_0.5.0-1_meson.ipk
rm -fr /etc/triggerhappy
cp -R "${FOLDER}"triggerhappy /etc/
cp -rf "${FOLDER}"triggerhappy.init /etc/init.d/triggerhappy
chmod 755 /etc/init.d/triggerhappy

# upmpdcli
opkg install "${FOLDER}"jsoncpp_1.8.4-1_meson.ipk
opkg install "${FOLDER}"libmicrohttpd_0.9.38-1.1_meson.ipk --nodeps
opkg install "${FOLDER}"libupnpp_0.17.0-1_meson.ipk
opkg install "${FOLDER}"upmpdcli_1.4.0-1_meson.ipk
if ! grep -q upmpdcli /etc/passwd; then
  echo "upmpdcli:*:89:89:upmpdcli:/var:/bin/false" >> /etc/passwd
fi
if ! grep -q upmpdcli /etc/shadow; then
  echo "upmpdcli:*:0:0:99999:7:::" >> /etc/shadow
fi
if ! grep -q upmpdcli /etc/group; then
  echo "upmpdcli:x:89:" >> /etc/group
fi
cp -R ${FOLDER}config/upmpdcli /etc/config/upmpdcli
/etc/init.d/upmpdcli enable
/etc/init.d/upmpdcli start
/etc/init.d/dlnainit disable

# MiniDLNA
#opkg install "${FOLDER}"libexif_0.6.21-1_meson.ipk
#opkg install "${FOLDER}"libjpeg_6b-1_meson.ipk
#opkg install "${FOLDER}"minidlna_1.1.3-1_meson.ipk
#/etc/init.d/minidlna enable
#/etc/init.d/minidlna start

# lighthttpd
rm -fr /www /www1
mkdir /www
opkg install "${FOLDER}"lighttpd_1.4.35-2_meson.ipk
opkg install "${FOLDER}"lighttpd-mod-cgi_1.4.35-2_meson.ipk
/bin/rm -fr /etc/lighttpd
/bin/cp -R "${FOLDER}"lighttpd /etc/
/etc/init.d/lighttpd enable
/etc/init.d/lighttpd start

# luci
opkg install "${FOLDER}"lua_5.1.5-1_meson.ipk
opkg install "${FOLDER}"libuci-lua_2014-04-11.1-1_meson.ipk 
opkg install "${FOLDER}"libubus-lua_2014-09-17-4c4f35cf2230d70b9ddd87638ca911e8a563f2f3_meson.ipk
opkg install "${FOLDER}"luci-base_0.12\+git-16.038.38474-0d510b2-1_meson.ipk 
opkg install "${FOLDER}"luci-mod-admin-full_0.12\+git-16.038.38474-0d510b2-1_meson.ipk 
opkg install "${FOLDER}"luci-theme-bootstrap_0.12\+git-16.038.38474-0d510b2-1_meson.ipk
opkg install "${FOLDER}"luci-i18n-russian_0.12\+git-16.038.38474-0d510b2-1_meson.ipk
opkg install "${FOLDER}"luci-lib-nixio_0.12\+git-16.038.38474-0d510b2-1_meson.ipk 
opkg install "${FOLDER}"luci_0.12\+git-16.038.38474-0d510b2-1_meson.ipk --nodeps

# Radio
/bin/cp -R "${FOLDER}"wifiradio /etc/
chmod -R 755 /etc/wifiradio/
/bin/cp -rf "${FOLDER}"www /
chmod -R 755 /www/cgi-bin/
/bin/cp -R "${FOLDER}"config /etc
/bin/cp "${FOLDER}"rc.local /etc/rc.local

# RU Sound
/bin/cp -rf "${FOLDER}"sound /usr/share/

# ympd
opkg install "${FOLDER}"ympd_2018-03-29_meson.ipk
/etc/init.d/ympd enable

# mount usb flash into media sd* dir
/bin/cp -R "${FOLDER}"10-mount /etc/hotplug.d/block/
chmod 755 /etc/hotplug.d/block/10-mount

/bin/mv -f /usr/share/sound/no_channel.opus /usr/share/sound/no_channel_.opus

# Allow samba operate with root files
/bin/cp -f "${FOLDER}"smb.conf-template /etc/samba
/etc/init.d/samba restart

# syncthing
opkg install  "${FOLDER}"syncthing_1.3.4-2_meson.ipk
cp -R ${FOLDER}config/syncthing /etc/config/syncthing
/etc/init.d/syncthing start
sleep 2
/etc/init.d/syncthing stop
sed -i 's@\/Sync@\/media\/public/\Sync@' /etc/syncthing/config.xml
/etc/init.d/syncthing start
