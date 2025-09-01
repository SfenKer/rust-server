#!/bin/bash

# Permissions
setfacl -R -d -m u:admin:rwx /home/container/

# Invoke Script
su -m admin -c "/home/container/scripts/shell/run_server.sh" &
SCRIPT_PID=$!

# Signal Handler
trap "echo '{\"Identifier\":-1,\"Message\":\"quit\",\"Name\":\"WebRcon\"}' | websocat ws://127.0.0.1:$RCON_PORT/$RCON_PASSWORD > /dev/null 2>&1" SIGINT SIGTERM
wait $SCRIPT_PID