#!/usr/bin/env bash

PROJECT_NAME="zho"

echo "Stopping cluster and local registry..."

docker stop "${PROJECT_NAME}-kind-control-plane" "${PROJECT_NAME}-kind-registry"

echo "Done."
