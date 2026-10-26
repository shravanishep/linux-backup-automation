#!/bin/bash

##############################################################################
# backup.sh — Automated file backup script
# Coursera: Hands-on Introduction to Linux Commands and Shell Scripting
# IBM Final Project
#
# USAGE:
#   ./backup.sh <targetDirectory> <destinationDirectory>
#
# DESCRIPTION:
#   Finds files modified in the last 24 hours inside targetDirectory,
#   archives them into a timestamped .tar.gz file, and saves the
#   archive to destinationDirectory.
##############################################################################

# ─── Argument validation ────────────────────────────────────────────────────

# [TASK 1] Check that exactly two arguments were provided
if [[ $# != 2 ]]; then
    echo "ERROR: Invalid number of arguments."
    echo "Usage: ./backup.sh target_directory destination_directory"
    exit 1
fi

# [TASK 2] Assign the first and second command-line arguments
targetDirectory=$1
destinationDirectory=$2

# [TASK 3] Display the values of the two variables
echo "Target directory:      $targetDirectory"
echo "Destination directory: $destinationDirectory"

# ─── Validate source directory ───────────────────────────────────────────────

# [TASK 4] Verify the target directory exists
if [[ ! -d "$targetDirectory" ]]; then
    echo "ERROR: Target directory '$targetDirectory' does not exist."
    exit 1
fi

# ─── Timestamps ─────────────────────────────────────────────────────────────

# [TASK 5] Get current timestamp in seconds since epoch
currentTS=$(date +%s)

# [TASK 6] Calculate yesterday's timestamp (24 hours ago)
yesterdayTS=$(( currentTS - 86400 ))

# ─── Archive filename ────────────────────────────────────────────────────────

# [TASK 7] Define the backup archive filename using the current timestamp
#          Format: backup-<timestamp>.tar.gz
backupFileName="backup-${currentTS}.tar.gz"

# ─── Prepare destination ────────────────────────────────────────────────────

# [TASK 8] Capture the absolute path of the destination directory
#          (cd into it so we have an absolute path; create it if it doesn't exist)
mkdir -p "$destinationDirectory"
cd "$destinationDirectory" || { echo "ERROR: Cannot access destination '$destinationDirectory'."; exit 1; }
destAbsPath=$(pwd)

# Return to the original working directory
cd - > /dev/null || exit 1

# ─── Collect files to back up ────────────────────────────────────────────────

# [TASK 9] Move into the target directory to iterate its contents
cd "$targetDirectory" || { echo "ERROR: Cannot access target '$targetDirectory'."; exit 1; }

# Declare array to hold files that qualify for backup
declare -a toBackup

# [TASK 10] Loop through all items in the target directory
for file in *; do
    # Only process regular files (skip directories and non-files)
    if [[ -f "$file" ]]; then
        # [TASK 11] Compare file modification time to yesterdayTS
        #           Include only files modified more recently than 24 hours ago
        fileTS=$(date -r "$file" +%s 2>/dev/null)
        if [[ -n "$fileTS" ]] && (( fileTS > yesterdayTS )); then
            toBackup+=("$file")
        fi
    fi
done

# ─── Create the archive ──────────────────────────────────────────────────────

# [TASK 12] Create the compressed archive if there are files to back up
if [[ ${#toBackup[@]} -gt 0 ]]; then
    echo "Files to back up (${#toBackup[@]}):"
    for f in "${toBackup[@]}"; do echo "  - $f"; done

    tar -czf "$backupFileName" "${toBackup[@]}"
    if [[ $? -ne 0 ]]; then
        echo "ERROR: tar failed to create archive."
        exit 1
    fi

    # [TASK 13] Move the completed archive to the destination directory
    mv "$backupFileName" "$destAbsPath/"
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to move archive to '$destAbsPath/'."
        exit 1
    fi

    echo "SUCCESS: Backup archive created → $destAbsPath/$backupFileName"
else
    echo "INFO: No files modified in the last 24 hours. No backup created."
fi
