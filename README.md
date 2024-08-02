# docker-volume-restore-backup

Bash scripts to restore / backup docker volumes

## Docker Volume Backup / Restore

```
This script uses tar to archive files for Docker volumes.

Backup Usage:
    bash dvol.sh backup [volume name] [volume path] (optional)[backup_output] (optional)[OPTIONS]

Backup Examples:
    Standard usage:
    Command : bash dvol.sh backup nginx-vol /var/www/html
    Output  : ./backup/20240704120857_nginx-vol__var_www_html.tar

    Custom output file name:
    Command : bash dvol.sh backup nginx-vol /var/www/html ~/nginx-vol.tar
    Output  : ~/nginx-vol.tar

    Custom output directory:
    Command : bash dvol.sh backup nginx-vol /var/www/html ~/
    Output  : ~/20240704120857_nginx-vol__var_www_html.tar

    With different compression format:
    Command : bash dvol.sh backup nginx-vol /var/www/html --format=gz
    Output  : ./backups/nginx-vol.tar.gz

Backup Options:
    --format=[gz,bz2]   : Specify the compression format (default: tar).

Restore Usage:
    Note: This action will restart containers attached to volume.
    bash dvol.sh restore [volume_name] [volume_path] [path_to_backup_file] [OPTIONS]

Restore Example:
    With options:
    Command : bash dvol.sh restore nginx-vol /var/www/html ./backups/20240704120857_nginx-vol__var_www_html.tar --clean --force

Restore Options:
    --clean : Remove the existing content at [volume_path] in the container before restoring from the backup.
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Author

Alvareksa A.

a_adhipramana@yahoo.com
