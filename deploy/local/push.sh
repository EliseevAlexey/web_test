# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"

git add . && git commit -m "$@" && git push
$SSH_COMMAND 'cd ./$PROJECT_NAME/deploy && git pull && ./deploy.sh'
