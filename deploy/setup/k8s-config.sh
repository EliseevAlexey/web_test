BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

blue 'microk8s status --wait-ready'
microk8s status --wait-ready

blue 'microk8s start'
microk8s start

blue 'microk8s enable registry'
microk8s enable registry

blue 'microk8s ingress'
microk8s enable ingress

blue 'echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases'
echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases

blue 'source ~/.bashrc'
source ~/.bashrc
