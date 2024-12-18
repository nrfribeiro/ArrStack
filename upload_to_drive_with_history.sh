#!/bin/bash

# Check if gdrive is installed
if ! command -v gdrive &> /dev/null; then
    echo "gdrive is not installed. Please install it first."
    exit 1
fi

# Check for input arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <folder_path> [google_drive_folder_id]"
    exit 1
fi

# Variables
FOLDER_PATH="$1"
DRIVE_FOLDER_ID="${2:-}"  # Optional Google Drive folder ID
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TAR_FILE="/tmp/$(basename "$FOLDER_PATH")_$TIMESTAMP.tar.gz"
MAX_BACKUPS=3

# Compress the folder
echo "Compressing folder..."
if tar -czf "$TAR_FILE" -C "$(dirname "$FOLDER_PATH")" "$(basename "$FOLDER_PATH")"; then
    echo "Folder compressed to $TAR_FILE."
else
    echo "Error: Failed to compress the folder."
    exit 1
fi

# Upload to Google Drive
echo "Uploading to Google Drive..."
if [ -z "$DRIVE_FOLDER_ID" ]; then
    FILE_ID=$(gdrive files up"$(basename "$TAR_FILE")" "$TAR_FILE" | awk '/Uploaded/ {print $2}')
else
    FILE_ID=$(gdrive files upload --parent "$DRIVE_FOLDER_ID"  "$(basename "$TAR_FILE")" "$TAR_FILE" | awk '/Uploaded/ {print $2}')
fi

if [ -n "$FILE_ID" ]; then
    echo "Upload successful. File ID: $FILE_ID."
else
    echo "Error: Upload failed."
    exit 1
fi

# Cleanup local tar.gz
rm -f "$TAR_FILE"
echo "Temporary tar.gz file deleted."

# Manage backup history (keep only the latest MAX_BACKUPS files)
echo "Managing backup history on Google Drive..."
if [ -z "$DRIVE_FOLDER_ID" ]; then
    FILE_LIST=$(gdrive files list --query "name contains '$(basename "$FOLDER_PATH")_' and mimeType = 'application/gzip'" --order "createdTime desc" --no-header --max 100)
else
    FILE_LIST=$(gdrive files list --query "'$DRIVE_FOLDER_ID' in parents and name contains '$(basename "$FOLDER_PATH")_' and mimeType = 'application/gzip'" --order "createdTime desc" --no-header --max 100)
fi

FILE_IDS_TO_DELETE=$(echo "$FILE_LIST" | tail -n +$((MAX_BACKUPS + 1)) | awk '{print $1}')

if [ -n "$FILE_IDS_TO_DELETE" ]; then
    echo "Deleting old backups..."
    while read -r OLD_FILE_ID; do
        gdrive files delete "$OLD_FILE_ID"
        echo "Deleted file ID: $OLD_FILE_ID"
    done <<< "$FILE_IDS_TO_DELETE"
else
    echo "No old backups to delete."
fi

echo "Backup process completed successfully."
