#!/bin/bash

PUID=${PUID:-0}
PGID=${PGID:-0}

# Create group and user if PUID/PGID are set to non-root
if [ "$PUID" != "0" ] && [ "$PGID" != "0" ]; then
    if ! getent group uldas > /dev/null 2>&1; then
        groupadd -g "$PGID" uldas
    fi

    if ! getent passwd uldas > /dev/null 2>&1; then
        useradd -u "$PUID" -g "$PGID" -d /app -s /bin/bash uldas
    fi

    chown -R uldas:uldas /app/config

    echo "Running as user uldas (PUID=$PUID, PGID=$PGID)"
    exec gosu uldas python ULDAS.py "$@"
else
    echo "Running as root"
    exec python ULDAS.py "$@"
fi
