#!/bin/sh

THIS_FOLDER="$(dirname "${BASH_SOURCE[0]}")"
read -d '' HELP_MESSAGE << EOF
Docker Volume Backup / Restore

This script uses tar to archive files for Docker volumes.

Backup Usage:
    bash $0 backup [volume name] [volume path] (optional)[backup output] (optional)[OPTIONS]
    
Backup Examples:
    Standard usage:
    Command : bash $0 backup nginx-vol /var/www/html
    Output  : ./backup/20240704120857_nginx-vol__var_www_html.tar

    Custom output file name:
    Command : bash $0 backup nginx-vol /var/www/html ~/nginx-vol.tar
    Output  : ~/nginx-vol.tar

    Custom output directory:
    Command : bash $0 backup nginx-vol /var/www/html ~/
    Output  : ~/20240704120857_nginx-vol__var_www_html.tar

    With different compression format:
    Command : bash $0 backup nginx-vol /var/www/html --format=gz
    Output  : ./backups/nginx-vol.tar.gz

Backup Options:
    --format=[gz,bz2]   : Specify the compression format (default: tar).

Restore Usage:
    Note: This action will restart containers attached to volume.
    bash $0 restore [volume_name] [volume_path] [path_to_backup_file] [OPTIONS]

Restore Example:
    With options:
    Command : bash $0 restore nginx-vol /var/www/html ./backups/20240704120857_nginx-vol__var_www_html.tar --clean --force

Restore Options:
    --clean : Remove the existing content at [volume_path] in the container before restoring from the backup.
EOF

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "$HELP_MESSAGE"
    exit 1
fi

if [[ "$1" == "backup" ]]; then
    bash "$THIS_FOLDER/bin/backup-volume.sh" "$@"
elif [[ "$1" == "restore" ]]; then
    bash "$THIS_FOLDER/bin/restore-volume.sh" "$@"
else
    echo "$HELP_MESSAGE"
fi