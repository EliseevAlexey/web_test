BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

ENV="dev"
GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
REPOSITORY_URL="localhost:32000"  # This is trusted storage prefix to support local repository in microk8s
APP_NAME="backend"
APP_TAG="latest"
APP_DIR="$GIT_ROOT_DIR/$APP_NAME"
HELM_CHARTS_PATH="$GIT_ROOT_DIR/deploy/helm/common/"
APP_HELM_VALUES="${GIT_ROOT_DIR}/$APP_NAME/k8s/values/$ENV.yaml"

blue "docker build -q $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker build -q $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG

blue "docker push -q $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker push -q $REPOSITORY_URL/$APP_NAME:$APP_TAG

blue "microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG"
microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG

HELM_CMD="helm install $APP_NAME $HELM_CHARTS_PATH --values $APP_HELM_VALUES"
blue $HELM_CMD
$HELM_CMD
