#!/bin/bash

mkdir -p ~/storage/oxide-installer
echo "[Oxide Installer] Checking for updates, please wait."

if [ ! -f ~/storage/oxide-installer/version ]; then
    INSTALLED_VERSION="null"
else
    INSTALLED_VERSION=$(cat ~/storage/oxide-installer/version)
fi

LATEST_VERSION=$(curl -s https://api.github.com/repos/OxideMod/Oxide.Rust/releases/latest | jq -r .tag_name)

if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then

    echo "[Oxide Installer] Oxide update is available, installing latest oxide version."
    echo "[Oxide Installer] Installed Version: $INSTALLED_VERSION"
    echo "[Oxide Installer] Latest Version:    $LATEST_VERSION"

    rm -rf /tmp/oxide-installer
    mkdir -p /tmp/oxide-installer

    curl -Ls "https://github.com/OxideMod/Oxide.Rust/releases/download/$LATEST_VERSION/Oxide.Rust-linux.zip" -o /tmp/oxide-installer/Oxide.Rust.zip

    unzip -o /tmp/oxide-installer/Oxide.Rust.zip -d /tmp/oxide-installer
    rm -f /tmp/oxide-installer/Oxide.Rust.zip

    cp -rf /tmp/oxide-installer/* ~/server/
    echo "$LATEST_VERSION" > ~/storage/oxide-installer/version

    rm -rf /tmp/oxide-installer

    echo "[Oxide Installer] Oxide $LATEST_VERSION was installed."
else
    echo "[Oxide Installer] There is no available updates."
fi