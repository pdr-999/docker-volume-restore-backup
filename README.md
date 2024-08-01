# docker-volume-restore-backup

Bash scripts to restore / backup docker volumes

## Docker Volume Backup / Restore

### Backup Usage:

```
bash dvol.sh backup [container id or name] [directory of container to zip] (optional)[backup outout]
```

#### Backup Example:

```
Command : bash dvol.sh backup nginx /var/www/html
Output : ./backup/20240704120857_nginx.tar

Command : bash dvol.sh backup nginx /var/www/html ./backups/nginx.tar
Output  : ./backups/nginx.tar
```

### Restore Usage:

(This will stop and start container)

```
bash dvol.sh restore [volume name] [volume folder in container] [path to backup file] [OPTIONS]
```

#### Restore Example:

```
Command : bash dvol.sh restore docker-volume-restore-backup_nginx-vol /var/www/html ./backups/nginx.tar
Command : bash dvol.sh restore docker-volume-restore-backup_nginx-vol /var/www/html ./backups/nginx.tar --clean
```

#### Restore Options:

```
--clean : rm -rf [volume folder in container] before unzipping
--force : skip `do you want to stop container` prompt when restoring
```
