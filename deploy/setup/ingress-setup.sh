BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}


GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
INGRESS_HELM_PATH="$GIT_ROOT_DIR/deploy/helm/ingress"
ENV="dev"

HELM_CMD=helm install ingress $INGRESS_HELM_PATH --values "$INGRESS_HELM_PATH/values/$ENV.yml"
blue "$HELM_CMD"
$HELM_CMD
