#!/bin/bash
# Fail on any error
set -e

GIT_ROOT_DIR="$(git rev-parse --show-toplevel)"
echo "Apply k8s updates"
microk8s kubectl apply -f "$GIT_ROOT_DIR/deploy/k8s/"

REPOSITORY_URL="localhost:32000"
APP_NAME="web_test"
APP_TAG="latest"
APP_DIR="$GIT_ROOT_DIR/app"

echo "Building application image..."
docker build -q $APP_DIR -t $REPOSITORY_URL/$APP_NAME:$APP_TAG
echo "Pushing application image..."
docker push -q $REPOSITORY_URL/$APP_NAME:$APP_TAG
echo "Pulling application image..."
microk8s ctr image pull $REPOSITORY_URL/$APP_NAME:$APP_TAG

echo "Apply application updates..."
microk8s kubectl rollout restart deployment
