# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"
APP_PATH="/root/$APP_NAME"

$SSH_COMMAND "git clone $REPO_PATH && $APP_PATH/deploy/setup/env-setup.sh"
$SSH_COMMAND "$APP_PATH/deploy/setup/k8s-config.sh"
$SSH_COMMAND "cd $APP_PATH && ./deploy/setup/ingress-config.sh"
$SSH_COMMAND "cd $APP_PATH && ./deploy/deploy.sh"

open "http://$SERVER_HOST"
echo "Setup complete!"
