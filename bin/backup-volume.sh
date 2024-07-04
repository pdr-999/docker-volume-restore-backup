THIS_FOLDER=$(dirname "$(readlink -f "$0")") # Absolute path to script

UTC_DATE=$(date -u +"%Y%m%d%H%M%S")
CONTAINER_ID_NAME=$1
CONTAINER_VOL_PATH=$2
OUTPUT="${UTC_DATE}_${CONTAINER_ID_NAME}.tar"
BACKUP_FOLDER="$THIS_FOLDER/../backups"

CUSTOM_OUTPUT=$3

if [ -z $3 ]; then
    BACKUP_FOLDER=$(dirname "$3")
    OUTPUT=$(basename "$3")
fi

docker run --rm --volumes-from $CONTAINER_ID_NAME \
    -v $BACKUP_FOLDER:/backup busybox:stable \
    tar cvf /backup/$OUTPUT $CONTAINER_VOL_PATH \