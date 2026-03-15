#!/bin/sh

STATE_FILE="/opt/audio-system/manager/state.json"

SERVICES="spotify bluetooth linein dlnainit"

stop_all() {
    for svc in $SERVICES; do
        [ -x "/etc/init.d/$svc" ] && /etc/init.d/$svc stop >/dev/null 2>&1
    done
}

set_state() {
    echo "{\"source\": \"$1\"}" > "$STATE_FILE"
}

start_source() {
    SRC="$1"

    stop_all

    if [ -x "/etc/init.d/$SRC" ]; then
        /etc/init.d/$SRC start
        set_state "$SRC"
        echo "Source active: $SRC"
    else
        echo "Error: service '$SRC' not found." >&2
        exit 1
    fi
}

case "$1" in
    spotify|bluetooth|linein|dlnainit)
        start_source "$1"
        ;;
    status)
        [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo '{"source":"none"}'
        ;;
    *)
        echo "Usage: $0 {spotify|bluetooth|linein|dlnainit|status}" >&2
        exit 1
        ;;
esac
