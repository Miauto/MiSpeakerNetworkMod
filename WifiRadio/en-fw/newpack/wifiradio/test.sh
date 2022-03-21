#!/bin/sh

if ! ping -q -c 2 -W 6 google.com > /dev/null; then
    echo "failed"
fi
