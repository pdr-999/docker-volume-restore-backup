THIS_FOLDER=$(dirname "$(readlink -f "$0")") # Absolute path to script

UUID=$(cat /proc/sys/kernel/random/uuid)

UTC_DATE=$(date -u +"%Y%m%d%H%M%S")
VOLUME_NAME=$2
VOLUME_PATH=$3
BACKUP_FOLDER="$THIS_FOLDER/../backups/"
VOLUME_FILENAME="${VOLUME_PATH//\//_}"
BACKUP_FILENAME="${UTC_DATE}_${VOLUME_NAME}_${VOLUME_FILENAME}"
FORMAT=""
OUTPUT_FLAG=$4
CUSTOM_FILENAME=0
FORMAT_FLAG=""

if ! [ -z "$4" ] && [[ "$4" != -* ]]; then
    # Use specified custom folder
    if [[ "${OUTPUT_FLAG: -1}" == */ ]]; then
        BACKUP_FOLDER="$(readlink -f $OUTPUT_FLAG)"
        mkdir -p $BACKUP_FOLDER
    # Use specified custom file name and folder
    else
        CUSTOM_FILENAME=1
        BACKUP_FOLDER="$(dirname $OUTPUT_FLAG)"
        BACKUP_FILENAME="$(basename "$OUTPUT_FLAG")"
    fi
fi

for arg in "$@"; do
    case $arg in
        --format=*)
            FORMAT_FLAG="${arg#*=}"  # Remove the prefix --format=
            ;;
        *)
    esac
done

# If format flag is specified
if [ -n "$FORMAT_FLAG" ]; then
    # Check available formats
    if [ "$FORMAT_FLAG" == "gz" ]; then
        FORMAT="--gzip"
    elif [ "$FORMAT_FLAG" == "bz2" ]; then
        FORMAT="--bzip2"
    # For some reason using xz does not work, the usage is wrong 
    # elif [ "$FORMAT_FLAG" == "xz" ]; then
    #     FORMAT="--xz"
    else
        echo "Error: Unrecognized --format='$FORMAT_FLAG'. Expected 'gz' or 'bz2'."
        exit 1
    fi
fi

# If user did not specify custom backup file name
if [ "$CUSTOM_FILENAME" -eq "0" ]; then
    BACKUP_FILENAME="$BACKUP_FILENAME.tar"

    # Append the format to the file name
    if [ -n "$FORMAT_FLAG" ]; then
        BACKUP_FILENAME="$BACKUP_FILENAME.$FORMAT_FLAG"
    fi
fi

docker run --rm \
    -v $VOLUME_NAME:$VOLUME_PATH \
    -v $BACKUP_FOLDER:/$UUID busybox:1.36.1-musl \
    tar --create --file="/$UUID/$BACKUP_FILENAME" $FORMAT $VOLUME_PATH \