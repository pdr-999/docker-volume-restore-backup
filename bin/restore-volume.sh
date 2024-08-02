THIS_FOLDER=$(dirname "$(readlink -f "$0")") # Absolute path to script

VOLUME_NAME=$2
CONTAINER_VOL_PATH=$3
PATH_TO_BACKUP_TAR=$(readlink -f "$4")
RESTORE_COMMAND="tar xf /backup/$PATH_TO_BACKUP_TAR"
CLEAN_FOLDER_BEFORE_UNZIP=false
FORCE=false

for arg in "$@"
do
    if [ "$arg" = "--clean" ]; then
        CLEAN_FOLDER_BEFORE_UNZIP=true
    fi

    if [ "$arg" = "--force" ]; then
        FORCE=true
    fi
done

if ! [ -e "$PATH_TO_BACKUP_TAR" ]; then
    echo "Backup file doesn't exist"
    exit 1
fi

if [ "$CLEAN_FOLDER_BEFORE_UNZIP" = true ]; then
    RESTORE_COMMAND="rm -rf $CONTAINER_VOL_PATH/* && $RESTORE_COMMAND"
fi

# Check if volume exists
if ! docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "Volume $VOLUME_NAME doesn't exist."
    exit 1
fi

CONTAINER_IDS_WITH_THIS_VOLUME=$(docker ps -q --filter "volume=$VOLUME_NAME")

# Check for containers with attached with this volume
if ! [ -z "$CONTAINER_IDS_WITH_THIS_VOLUME" ]; then

    echo -e "Running containers detected. This will stop, restore, then start restart the following container(s):\n"

    for CONTAINER_ID in $CONTAINER_IDS_WITH_THIS_VOLUME; do
        CONTAINER_NAME=$(docker inspect --format '{{ .Name }}' $CONTAINER_ID)
        echo "Container ID: $CONTAINER_ID"
        echo "Container Name: $CONTAINER_NAME"
        echo "---"
    done 

    # Prompt if force is unspecified
    if [ "$FORCE" = false ]; then
        read -p "Do you want to continue (y/n)? " answer

        if ! [ "$answer" = "y" ]; then
            exit 1;
        fi
    fi
fi

echo "Restoring volume..."

# Stop containers first
for CONTAINER_ID in $CONTAINER_IDS_WITH_THIS_VOLUME; do
    docker stop $CONTAINER_ID
done 

# Restore it
docker run --rm --mount source=$VOLUME_NAME,destination=$CONTAINER_VOL_PATH -v $PATH_TO_BACKUP_TAR:/backup/$PATH_TO_BACKUP_TAR busybox:1.36.1-musl /bin/sh -c "$RESTORE_COMMAND"

# Then Restart it
for CONTAINER_ID in $CONTAINER_IDS_WITH_THIS_VOLUME; do
    docker restart $CONTAINER_ID
done 
