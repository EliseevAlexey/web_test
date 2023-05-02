BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
REPOSITORY_URL="localhost:32000"
APP_NAME="web_test"
APP_TAG="latest"
APP_DIR="$GIT_ROOT_DIR/app"

blue 'microk8s kubectl apply -f "$GIT_ROOT_DIR/deploy/k8s/""'
microk8s kubectl apply -f "$GIT_ROOT_DIR/deploy/k8s/"

blue "docker build -q $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker build -q $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG

blue "docker push -q $REPOSITORY_URL/$APP_NAME:$APP_TAG"
docker push -q $REPOSITORY_URL/$APP_NAME:$APP_TAG

blue "microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG"
microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG

blue "microk8s kubectl rollout restart deployment"
microk8s kubectl rollout restart deployment
