#!/bin/bash

# Install Server & Oxide
~/scripts/shell/installer/rust_installer.sh
~/scripts/shell/installer/oxide_installer.sh

# Generate Startup Command
function add_argument { 
    if [ ! -z "${!2}" ]; then
        SERVER_COMMAND_ARGUMENTS+=("+${1}")
        SERVER_COMMAND_ARGUMENTS+=("${!2}")
    fi
}

SERVER_COMMAND_ARGUMENTS=()

if [ -n "$SERVER_ARGUMENTS" ]; then
    while IFS= read -r arg; do
        SERVER_COMMAND_ARGUMENTS+=("$arg")
    done < <(printf '%s\n' "$SERVER_ARGUMENTS")
fi

add_argument "server.identity" SERVER_IDENTITY

add_argument "server.port" SERVER_PORT
add_argument "server.queryport" SERVER_QUERYPORT

if [ -z "$SERVER_LEVELURL" ]; then
    add_argument "server.worldsize" SERVER_WORLDSIZE
    add_argument "server.seed" SERVER_SEED
else
    add_argument "server.levelurl" SERVER_LEVELURL
fi

add_argument "server.hostname" SERVER_NAME
add_argument "server.description" SERVER_DESCRIPTION

add_argument "server.url" SERVER_URL
add_argument "server.headerimage" SERVER_BANNER_URL

add_argument "server.maxplayers" SERVER_MAXPLAYERS
add_argument "server.saveinterval" SERVER_SAVE_INTERVAL

add_argument "rcon.web" RCON_WEB
add_argument "rcon.port" RCON_PORT
add_argument "rcon.password" RCON_PASSWORD

add_argument "app.port" APP_PORT

# Start Server
cd /home/container/server || exit 1
exec /home/container/server/RustDedicated "${SERVER_COMMAND_ARGUMENTS[@]}"