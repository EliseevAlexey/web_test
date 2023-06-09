#!/bin/sh
set -e

# Load env variables
ROOT_DIR="$(git rev-parse --show-toplevel)"
source "$ROOT_DIR/deploy/local/local.env"
SERVER_APP_PATH="/root/$PROJECT_NAME"

$SSH_COMMAND "git clone $REPO_PATH && cd $SERVER_APP_PATH && ./deploy/setup/env-setup.sh"
$SSH_COMMAND "cd $SERVER_APP_PATH && ./deploy/setup/k8s-config.sh"
$SSH_COMMAND "cd $SERVER_APP_PATH && ./deploy/deploy.sh"

sleep 3
open "http://$SERVER_HOST"
echo "Setup complete!"
