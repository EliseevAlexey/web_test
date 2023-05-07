BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

color() {
    APP="deploy"
    CMD=$1
    printf "${CYAN}$APP${NC}: ${BLUE}$@${NC}\n"
}


ENV="dev"
ROOT_DIR="$(git rev-parse --show-toplevel)"
REPOSITORY_URL="localhost:32000"  # This is trusted storage prefix to support local repository in microk8s
APP_NAME="backend"
APP_TAG="latest"
APP_DIR="$ROOT_DIR/$APP_NAME"
HELM_CHARTS_PATH="$ROOT_DIR/deploy/helm/common/"
APP_HELM_VALUES="${ROOT_DIR}/$APP_NAME/k8s/values/$ENV.yaml"

color "docker build $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker build $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG

color "docker push $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker push $REPOSITORY_URL/$APP_NAME:$APP_TAG

color "microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG"
microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG

HELM_CMD="helm upgrade $APP_NAME $HELM_CHARTS_PATH --values $APP_HELM_VALUES --install"
color $HELM_CMD
$HELM_CMD
