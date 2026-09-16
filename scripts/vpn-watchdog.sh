#!/bin/bash

TARGET="8.8.8.8"
NOW=$(date)

log_message() {
	echo "[$NOW] vpn-watchdog: $1"
}

if ! ping -c 1 -W 2 $TARGET > /dev/null 2>&1; then
	log_message "Internet is DOWN! - Attempting to restart connection"
	systemctl restart systemd-networkd NetworkManager
fi
