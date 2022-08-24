#!/bin/bash
set -e

# Prerequisites: set these two environment variables for the Tiltfile
#SOURCE_IMAGE
#K8S_TEST_CONTEXT

# Delete the previous run
rm -rf test-result

# If the node_modules directory is hanging around due to development, delete it
rm -rf node_modules

# Install this accelerator in the current cluster.
echo 'applying the accelerator...'
tanzu accelerator apply -f k8s-resource.yaml -n accelerator-system
sleep 15

# Generate a function project zip from the accelerator 
mkdir -p test-result
pushd test-result
echo 'port-forward the acclerator service so we can access on localhost...'
kubectl port-forward service/acc-server -n accelerator-system 8877:80 &
PORT_FORWARD_PID=$!
sleep 15

echo 'use the accelerator to generate a project...'
tanzu accelerator generate node-function --options '{"projectName": "nodefunc", "includeTap": true}' --server-url http://localhost:8877
tar -xzvf nodefunc.zip
pushd nodefunc

echo 'terminating the port forwarding... '
kill -9 $PORT_FORWARD_PID

#echo 'tilting up...'
#tilt up
#sleep 30

echo 'curling the expected endpoint'
curl localhost:8080

popd
popd 
# rm -rf test-result

# Remove the accelerator
tanzu accelerator delete node-function

# Check that it removed? 
