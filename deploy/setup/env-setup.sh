RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

exec() {
  COMMANDS=$@
  blue $COMMANDS
  $COMMANDS
}

# Docker https://docs.docker.com/engine/install/ubuntu/
APP_NAME='docker'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"
    exec sudo apt-get update
    exec sudo apt-get install -y ca-certificates curl gnupg
    exec sudo install -m 0755 -d /etc/apt/keyrings
    exec curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    exec sudo chmod a+r /etc/apt/keyrings/docker.gpg
    exec echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    exec sudo apt update
    exec sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#    exec sudo groupadd docker
#    exec sudo usermod -aG docker $USER
else
    echo "-- '$APP_NAME' already installed, skipping"
fi

# K8S https://microk8s.io/docs/getting-started
APP_NAME='microk8s'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"
    exec sudo apt-get update
    exec sudo snap install microk8s --classic --channel=1.27
    exec sudo usermod -a -G microk8s $USER
    exec sudo chown -f -R $USER ~/.kube
    exec sudo su - $USER
    exec microk8s status --wait-ready
    exec microk8s start
    exec microk8s enable registry ingress
    exec echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases
    exec source ~/.bashrc
else
    echo "-- '$APP_NAME' already installed, skipping"
fi
