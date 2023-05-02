# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"

$SSH_COMMAND "git clone $REPO_PATH && /root/$APP_NAME/deploy/setup/env-setup.sh"
$SSH_COMMAND "/root/$APP_NAME/deploy/setup/k8s-config.sh"
$SSH_COMMAND "cd /root/$APP_NAME && ./deploy/deploy.sh"

open "http://$SERVER_HOST"
echo "Setup complete!"
