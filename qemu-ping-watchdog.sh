#!/usr/bin/env bash

# Define the log file and the maximum log file size (in megabytes)
LOG_FILE="/path/to/logfile"
MAX_LOG_SIZE_MB=50

touch $LOG_FILE

# Function to log messages with timestamps
log_message() {
    local current_time
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$current_time] $1" >> "$LOG_FILE"
}

# Function to check and rotate log file if it exceeds the maximum size
rotate_log() {
    local log_size
    log_size=$(du -m "$LOG_FILE" | cut -f1)

    if [ "$log_size" -ge "$MAX_LOG_SIZE_MB" ]; then
        local backup_log_file
        backup_log_file="${LOG_FILE}.$(date +"%Y%m%d%H%M%S")"
        mv "$LOG_FILE" "$backup_log_file"
        touch "$LOG_FILE"
    fi
}

# VM list
VM="100 104 106 107 110"

# Rotate the log file before starting
rotate_log

# Loop through VMs
for VMID in $VM; do
    log_message "Pinging QEMU agent for VM $VMID..."

    if [ -f /etc/pve/qemu-server/$VMID.conf ]; then
        /usr/sbin/qm agent $VMID ping || (
            log_message "QEMU agent ping failed for VM $VMID"
            /usr/sbin/qm unlock $VMID
            log_message "Unlocking VM $VMID"
            /usr/sbin/qm stop $VMID
            log_message "Stopping VM $VMID"
            /usr/sbin/qm start $VMID
            log_message "Starting VM $VMID"
        )
    else
        log_message "Configuration file for VM $VMID does not exist. Skipping actions."
    fi
done

# Rotate the log file after the script has completed
rotate_log
