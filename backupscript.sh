#!/bin/bash

#Configuration
SOURCE_DIR="/var/log"            # Directory to backup
BACKUP_DIR="/tmp/backups"        # Destination
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup_log.txt"

#Functions

log_message() {
    local MESSAGE="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $MESSAGE" | tee -a "$LOG_FILE"
}

check_directories() {
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Error: Source directory $SOURCE_DIR does not exist."
        exit 1
    fi

    if [ ! -d "$BACKUP_DIR" ]; then
        log_message "Backup directory not found. Creating $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
    fi
}

perform_backup() {
    log_message "Starting backup of $SOURCE_DIR..."
    
    # tar flags: -c (create), -z (gzip), -f (file)
    # 2> /dev/null silences standard error (optional, mostly for cleaner logs)
    if tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR" 2> /dev/null; then
        log_message "Success: Backup created at $BACKUP_DIR/$BACKUP_FILE"
    else
        log_message "Error: Backup operation failed."
        exit 1
    fi
}

#Execution
check_directories
perform_backup

# Cleanup: Delete backups older than 7 days
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;
log_message "Cleanup: Removed backups older than 7 days."
