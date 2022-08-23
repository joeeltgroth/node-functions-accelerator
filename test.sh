#!/bin/bash
#set -e

# Delete the previous run
rm -rf test-result

# Prerequisites: set these two environment variables for the Tiltfile
#SOURCE_IMAGE
#K8S_TEST_CONTEXT

# Install this accelerator in the current cluster.
tanzu accelerator apply -f k8s-resource.yaml -n accelerator-system

# Wait and check that it is ready? 
sleep 15

# Generate a function project zip from the accelerator 
mkdir -p test-result
pushd test-result
kubectl port-forward service/acc-server -n accelerator-system 8877:80 &
PORT_FORWARD_PID=$!
tanzu accelerator generate node-function --options '{"projectName": "nodejsfunctest", "includeTap": true}' --server-url http://localhost:8877
kill -9 $PORT_FORWARD_PID

# unzip
tar -xzvf nodejsfunctest.zip
pushd nodejsfunctest

# tilt up, wait, and curl the expectd endpoint
tilt up
sleep 30
curl localhost:8080

popd
popd 
# rm -rf test-result

# Remove the accelerator
tanzu accelerator delete node-function

# Check that it removed? 