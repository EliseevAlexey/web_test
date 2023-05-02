RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

blue() {
  printf "${BLUE}$@${NC}\n"
}

# Docker https://docs.docker.com/engine/install/ubuntu/
APP_NAME='docker'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"
    blue 'sudo apt-get update'
    sudo apt-get update

    blue 'exec sudo apt-get install -y ca-certificates curl gnupg'
    exec sudo apt-get install -y ca-certificates curl gnupg

    blue 'exec sudo install -m 0755 -d /etc/apt/keyrings'
    exec sudo install -m 0755 -d /etc/apt/keyrings

    blue 'exec curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
    exec curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    blue 'exec sudo chmod a+r /etc/apt/keyrings/docker.gpg'
    exec sudo chmod a+r /etc/apt/keyrings/docker.gpg

    blue 'deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
    exec echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    blue 'exec sudo apt update'
    exec sudo apt update

    blue 'exec sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
    exec sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "-- '$APP_NAME' already installed, skipping"
fi

# K8S https://microk8s.io/docs/getting-started
APP_NAME='microk8s'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"

    blue 'sudo apt-get update'
    sudo apt-get update

    blue 'sudo snap install microk8s --classic --channel=1.27'
    sudo snap install microk8s --classic --channel=1.27

    blue 'sudo usermod -a -G microk8s $USER'
    sudo usermod -a -G microk8s $USER

    blue 'sudo chown -f -R $USER ~/.kube'
    sudo chown -f -R $USER ~/.kube

    blue 'sudo su - $USER'
    sudo su - $USER

    blue 'microk8s status --wait-ready'
    microk8s status --wait-ready

    blue 'microk8s start'
    microk8s start

    blue 'microk8s enable registry ingress'
    microk8s enable registry ingress

    blue 'echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases'
    echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases

    blue 'source ~/.bashrc'
    source ~/.bashrc
else
    echo "-- '$APP_NAME' already installed, skipping"
fi
