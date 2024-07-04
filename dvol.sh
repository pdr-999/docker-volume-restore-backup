#!/bin/sh

THIS_FOLDER="$(dirname "${BASH_SOURCE[0]}")"
read -d '' HELP_MESSAGE << EOF
Docker Volume Backup / Restore

Backup Usage:
    bash $0 backup [container id or name] [directory of container to zip] (optional)[backup outout]
    
Backup Example:
    Command : bash $0 backup nginx /var/www/html
    Output  : ./backup/20240704120857_nginx.tar

    Command : bash $0 backup nginx-1 /var/www/html ./backups/nginx-1.tar
    Output  : ./backups/nginx-1.tar

Restore Usage:
    (This will stop and start container)
    bash $0 restore [volume name] [volume folder in container] [path to backup file] [OPTIONS]

Restore Example:
    Command : bash $0 restore docker-volume-restore-backup_nginx-vol /var/www/html ./backups/nginx-1.tar

    Command : bash $0 restore docker-volume-restore-backup_nginx-vol /var/www/html ./backups/nginx-1.tar --clean

Restore Options:
    --clean : rm -rf [volume folder in container] before unzipping
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