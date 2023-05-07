BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

color() {
    APP="k8s config"
    CMD=$1
    printf "${CYAN}$APP${NC}: ${BLUE}$@${NC}\n"
}


color 'microk8s status --wait-ready'
microk8s status --wait-ready

color 'microk8s start'
microk8s start

color 'microk8s enable helm'
microk8s enable helm

# color 'microk8s enable hostpath-storage'
# microk8s enable hostpath-storage

color 'microk8s enable dns'
microk8s enable dns

color 'microk8s ingress'
microk8s enable ingress

color 'microk8s enable registry'
microk8s enable registry

color "echo alias kubectl=microk8s kubectl' >> ~/.bash_aliases"
echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases

color 'source ~/.bashrc'
source ~/.bashrc

# HELM
color 'microk8s.kubectl config view --raw > ~/.kube/config'
microk8s.kubectl config view --raw > ~/.kube/config


ENV="dev"
GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
INGRESS_HELM_PATH="$GIT_ROOT_DIR/deploy/helm/ingress"

HELM_CMD="helm upgrade ingress $INGRESS_HELM_PATH/ --values $INGRESS_HELM_PATH/values/$ENV.yaml --install"
color "$HELM_CMD"
$HELM_CMD
