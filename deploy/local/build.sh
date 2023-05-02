# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"

docker build -q -t $APP_NAME "$ROOT_DIR/app"
