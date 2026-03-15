#!/bin/sh

MANAGER="/opt/audio-system/manager/audio_manager.sh"
STATE="/opt/audio-system/manager/state.json"
AUTO_SWITCH_FLAG="/opt/audio-system/manager/auto_switch.enabled"

echo "Content-Type: application/json"
echo ""

# parse QUERY_STRING
QS="$QUERY_STRING"

get_param() {
    echo "$QS" | tr '&' '\n' | grep "^$1=" | head -n1 | cut -d'=' -f2
}

ACTION=$(get_param action)
SRC=$(get_param src)
ENABLE=$(get_param enable)

case "$ACTION" in
    set_source)
        case "$SRC" in
            spotify|bluetooth|linein|dlnainit)
                "$MANAGER" "$SRC" >/dev/null 2>&1
                echo "{\"status\":\"ok\",\"source\":\"$SRC\"}"
                ;;
            *)
                echo "{\"status\":\"error\",\"error\":\"invalid source\"}"
                ;;
        esac
        ;;
    state)
        if [ -f "$STATE" ]; then
            SRC_CUR=$(awk -F'"' '{print $4}' "$STATE")
        else
            SRC_CUR="none"
        fi
        if [ -f "$AUTO_SWITCH_FLAG" ]; then
            AS="true"
        else
            AS="false"
        fi
        echo "{\"source\":\"$SRC_CUR\",\"auto_switch\":$AS}"
        ;;
    auto_switch)
        if [ "$ENABLE" = "1" ] || [ "$ENABLE" = "true" ]; then
            touch "$AUTO_SWITCH_FLAG"
        else
            rm -f "$AUTO_SWITCH_FLAG"
        fi
        if [ -f "$AUTO_SWITCH_FLAG" ]; then
            AS="true"
        else
            AS="false"
        fi
        echo "{\"status\":\"ok\",\"auto_switch\":$AS}"
        ;;
    *)
        echo "{\"status\":\"error\",\"error\":\"invalid action\"}"
        ;;
esac
