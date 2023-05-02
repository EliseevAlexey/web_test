#!/bin/bash
# Fail on any error
set -e

git_root_dir="$(git rev-parse --show-toplevel)"
echo "Apply k8s updates"
microk8s kubectl apply -f "$git_root_dir/deploy/k8s/"

REPOSITORY_URL="localhost:32000"
APP_NAME="web_test"
APP_TAG="latest"
APP_DIR="$git_root_dir/app"

echo "Building application image"
docker build $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG
echo "Pushing application image"
docker push $REPOSITORY_URL/$APP_NAME:$APP_TAG
echo "Pulling application image"
microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG

echo "Apply application updates"
microk8s kubectl rollout restart deployment
