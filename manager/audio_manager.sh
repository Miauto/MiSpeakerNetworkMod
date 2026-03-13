#!/bin/sh

STATE_FILE="/opt/audio-system/manager/state.json"

# Liste des services audio
SERVICES="spotify bluetooth linein dlnainit"

stop_all() {
    for svc in $SERVICES; do
        if [ -x "/etc/init.d/$svc" ]; then
            /etc/init.d/$svc stop >/dev/null 2>&1
        fi
    done
}

set_state() {
    echo "{\"source\": \"$1\"}" > "$STATE_FILE"
}

start_source() {
    SRC="$1"

    echo "Switching audio source to: $SRC"

    # Stop everything
    stop_all

    # Start the requested source
    if [ -x "/etc/init.d/$SRC" ]; then
        /etc/init.d/$SRC start
        set_state "$SRC"
        echo "Source active: $SRC"
    else
        echo "Error: service '$SRC' not found."
        exit 1
    fi
}

case "$1" in
    spotify|bluetooth|linein|dlnainit)
        start_source "$1"
        ;;
    status)
        cat "$STATE_FILE"
        ;;
    *)
        echo "Usage: $0 {spotify|bluetooth|linein|dlnainit|status}"
        exit 1
        ;;
esac
