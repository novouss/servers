#!/bin/bash
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[$(date)] Updating Valheim in $INSTALL_DIR ..."

steamcmd \
  +@sSteamCmdForcePlatformType linux \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \ # server files are free anyway
  +app_update 896660 validate \
  +quit

echo "[$(date)] Update complete."   
