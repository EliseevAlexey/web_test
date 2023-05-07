BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

blue 'microk8s status --wait-ready'
microk8s status --wait-ready

blue 'microk8s start'
microk8s start

blue 'microk8s enable helm'
microk8s enable helm

blue 'microk8s enable hostpath-storage'
microk8s enable hostpath-storage

blue 'microk8s enable dns'
microk8s enable dns

blue 'microk8s ingress'
microk8s enable ingress

blue 'microk8s enable registry'
microk8s enable registry

blue "echo alias kubectl=microk8s kubectl' >> ~/.bash_aliases"
echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases

blue 'source ~/.bashrc'
source ~/.bashrc


# HELM
blue 'microk8s.kubectl config view --raw > ~/.kube/config'
microk8s.kubectl config view --raw > ~/.kube/config


ENV="dev"
GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
INGRESS_HELM_PATH="$GIT_ROOT_DIR/deploy/helm/ingress"
echo "$INGRESS_HELM_PATH"

HELM_CMD="helm install ingress $INGRESS_HELM_PATH/ --values $INGRESS_HELM_PATH/values/$ENV.yaml"
blue "$HELM_CMD"
$HELM_CMD
