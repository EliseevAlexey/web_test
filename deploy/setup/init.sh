# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"

$SSH_COMMAND "git clone $REPO_PATH && cd ./$REPO_NAME && ./deploy/setup/env-setup.sh"
