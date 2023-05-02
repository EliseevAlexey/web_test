# Docker https://docs.docker.com/engine/install/ubuntu/
APP_NAME='docker'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"
    echo "Running: sudo apt-get update"
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "-- '$APP_NAME' already installed, skipping"
fi

# K8S https://microk8s.io/docs/getting-started
APP_NAME='microk8s'
if ! command -v $APP_NAME &> /dev/null
then
    echo "-- Installing '$APP_NAME'"
    echo "Running: sudo apt-get update"
    sudo apt-get update
    echo "Running: sudo snap install microk8s --classic --channel=1.27"
    sudo snap install microk8s --classic --channel=1.27
    echo "Running: sudo usermod -a -G microk8s $USER" 
    sudo usermod -a -G microk8s $USER
    echo "Running: sudo chown -f -R $USER ~/.kube"
    sudo chown -f -R $USER ~/.kube
    echo "Running: sudo su - $USER"
    sudo su - $USER
    echo "Running: microk8s status --wait-ready"
    microk8s status --wait-ready
    echo "Running: microk8s start"
    microk8s start
    echo "Running: microk8s enable registry"
    microk8s enable registry ingress
    echo "Running: echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases"
    echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases
    source ~/.bashrc
else
    echo "-- '$APP_NAME' already installed, skipping"
fi
