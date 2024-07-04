THIS_FOLDER=$(dirname "$(readlink -f "$0")") # Absolute path to script

UTC_DATE=$(date -u +"%Y%m%d%H%M%S")
CONTAINER_ID_NAME=$2
CONTAINER_VOL_PATH=$3
OUTPUT="${UTC_DATE}_${CONTAINER_ID_NAME}.tar"
BACKUP_FOLDER="$THIS_FOLDER/../backups/"

CUSTOM_OUTPUT=$(readlink -f "$4")

if ! [ -z "$4" ]; then
    BACKUP_FOLDER=$(dirname "$CUSTOM_OUTPUT")
    OUTPUT=$(basename "$CUSTOM_OUTPUT")
fi


docker run --rm --volumes-from $CONTAINER_ID_NAME \
    -v $BACKUP_FOLDER:/backup busybox:stable \
    tar cvf /backup/$OUTPUT $CONTAINER_VOL_PATH \