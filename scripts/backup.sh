#!/bin/bash/

BACKUP_MOUNT="/mnt/backup"
RESTIC_REPO="$BACKUP_MOUNT/restic"
RESTIC_PASSWORD="ERICKA_JANE_MELGAR"
RESTIC_PASSWORD="$HOME/.config/restic/password"

LOG_DIR="/var/log/server-backups"
LOG_FILE="$LOG_DIR/backup.log"
LAST_SUCCESS_FILE="$LOG_DIR/last-successful-backup.txt"

# Docker Compose files
COMPOSE_SERVARR="/home/novous/servarr/docker-compose.yml"
COMPOSE_BENTOPDF="/home/novous/bentopdf/docker-compose.yml"
COMPOSE_IMMICH="/mnt/storage1/immich/docker-compose.yml"

# Folders
BACKUP_PATHS=(
	"/home/novous/bentopdf",
	"/home/novous/scripts",
	"/home/novous/servarr",
	"/mnt/storage1/immich",
	"/mnt/storage1/share"
)

# Restic
export RESTIC_REPOSITORY="$RESTIC_REPO"
export RESTIC_PASSWORD="$RESTICE_PASSWORD"

mkdir -p "$LOG_DIR"

NOW=$(date)
log_message() {
	echo "[$NOW] backup: $1" >> "$LOG_FILE"
}

log_message "Backup has STARTED..."

if ! mountpoint -q "$BACKUP_MOUNT"; then
	log_message "Drive NOT MOUNTED at $BACKUP_MOUNT"
	log_message "Backup ABORTED"
	exit 1
fi

log_message "Stopping Docker containers..."
docker compose -f "$DOCKER_SERVARR" down >> "$LOG_FILE" 2>&1
docker compose -f "$DOCKER_BENTOPDF" down >> "$LOG_FILE" 2>&1
docker compose -f "$DOCKER_IMMICH" down >> "$LOG_FILE" 2>&1

log_message "Running restic backup..."

restic backup "${BACKUP_PATHS[@]}" >> "$LOG_FILE" 2>&1
RESTIC_EXIT_CODE=$?

log_message "Starting Docker containers..."
docker compose -f "$DOCKER_SERVARR" up >> "$LOG_FILE" 2>&1
docker compose -f "$DOCKER_BENTOPDF" up >> "$LOG_FILE" 2>&1
docker compose -f "$DOCKER_IMMICH" up >> "$LOG_FILE" 2>&1

END=$(date)

if [ $RESTIC_EXIT_CODE -eq 0 ]; then
	log_message "Backup SUCCESSUL: Finished at $END"
	echo "Last successful backup: $END" > "$LAST_SUCCESS_FILE"
else
	log_message "Backup FAILED: Finished at $END"
fi

echo "Run 'restic check' to validate. Read MANPAGE for status code definitions."
echo "Run sudo unmount $BACKUP_MOUNT if no issues were found"
exit $RESTIC_EXIT_CODE
