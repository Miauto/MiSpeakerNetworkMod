#!/bin/sh

MANAGER="/opt/audio-system/manager/audio_manager.sh"
STATE="/opt/audio-system/manager/state.json"

CURRENT=""
LAST_ACTIVE=""
AUTO_SWITCH_FLAG="/opt/audio-system/manager/auto_switch.enabled"

[ -f "$AUTO_SWITCH_FLAG" ] || touch "$AUTO_SWITCH_FLAG"

get_current() {
    if [ -f "$STATE" ]; then
        CURRENT=$(cat "$STATE" | awk -F'"' '{print $4}')
    else
        CURRENT=""
    fi
}

is_spotify_active() {
    pgrep librespot >/dev/null 2>&1 && return 0
    return 1
}

is_bt_active() {
    grep -q RUNNING /proc/asound/card0/pcm0p/sub0/status 2>/dev/null && return 0
    return 1
}

is_linein_active() {
    arecord -d 1 -f S16_LE -c 2 -r 44100 /dev/null 2>/dev/null | grep -q "frames" && return 0
    return 1
}

is_dlna_active() {
    pgrep dlna >/dev/null 2>&1 && return 0
    return 1
}

while true; do
    [ -f "$AUTO_SWITCH_FLAG" ] || { sleep 1; continue; }

    get_current

    if is_spotify_active; then LAST_ACTIVE="spotify"; fi
    if is_bt_active;      then LAST_ACTIVE="bluetooth"; fi
    if is_linein_active;  then LAST_ACTIVE="linein"; fi
    if is_dlna_active;    then LAST_ACTIVE="dlnainit"; fi

    if [ "$LAST_ACTIVE" != "" ] && [ "$LAST_ACTIVE" != "$CURRENT" ]; then
        echo "Auto-switch to $LAST_ACTIVE"
        $MANAGER "$LAST_ACTIVE"
    fi

    sleep 1
done
