# Steps

1. Provision Server
2. Populate deploy/local/local.env
3. Run deploy/local/server-ssh.sh
From Server
4. Setup git keys
5. Checkout repo
6. Run deploy/k8s-setup.sh to make sure everything is setup
Back to client:
7. Do changes, run deploy/local/push.sh
