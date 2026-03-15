#!/bin/sh

MANAGER="/opt/audio-system/manager/audio_manager.sh"
STATE="/opt/audio-system/manager/state.json"
AUTO_SWITCH_FLAG="/opt/audio-system/manager/auto_switch.enabled"

[ -f "$AUTO_SWITCH_FLAG" ] || touch "$AUTO_SWITCH_FLAG"

CURRENT=""
LAST_ACTIVE=""

get_current() {
    if [ -f "$STATE" ]; then
        CURRENT=$(awk -F'"' '{print $4}' "$STATE")
    else
        CURRENT=""
    fi
}

is_spotify_active() {
    ps | grep -v grep | grep -q "librespot" && return 0
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
    ps | grep -v grep | grep -q "dlna" && return 0
    return 1
}

while true; do
    [ -f "$AUTO_SWITCH_FLAG" ] || { sleep 1; continue; }

    get_current

    # Priorités : linein > bluetooth > spotify > dlnainit
    if is_linein_active; then LAST_ACTIVE="linein"
    elif is_bt_active; then LAST_ACTIVE="bluetooth"
    elif is_spotify_active; then LAST_ACTIVE="spotify"
    elif is_dlna_active; then LAST_ACTIVE="dlnainit"
    else LAST_ACTIVE=""
    fi

    if [ -n "$LAST_ACTIVE" ] && [ "$LAST_ACTIVE" != "$CURRENT" ]; then
        "$MANAGER" "$LAST_ACTIVE"
    fi

    sleep 1
done
