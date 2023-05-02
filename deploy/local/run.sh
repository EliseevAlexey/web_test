SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/local.env"
/bin/sh "$SCRIPT_DIR/build.sh"
docker run --rm -it -p 80:80 $APP_NAME
