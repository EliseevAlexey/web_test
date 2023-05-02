script_dir="$(dirname "$0")"
source "$script_dir/local.env"
/bin/sh "$script_dir/build.sh"
docker run --rm -it -p 80:80 $APP_NAME
