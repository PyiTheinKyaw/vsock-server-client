#!/bin/bash

function print_timestamp_message {
  timestamp=$(date +%Y-%m-%d_%H:%M:%S)
  echo -e "\033[1;32m$timestamp - $1\033[0m"
}

function print_docker_success_message {
  timestamp=$(date +%Y-%m-%d_%H:%M:%S)
  echo -e "\033[3;30;42m$timestamp - Docker Image built successfully.\033[0m"
}

function print_enclave_success_message {
  timestamp=$(date +%Y-%m-%d_%H:%M:%S)
  echo -e "\033[3;30;42m$timestamp - Build enclave image successfully with output filename as vsock_sample_server.eif\033[0m"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: $0 <-pt || -fl>"
  exit 0
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 -pt or $0 -fl"
  exit 1
fi

if [ "$1" == "-pt" ]; then
  print_timestamp_message "Building docker image of portable server."
  docker build -t vsock-server-portable -f DockerfilePT.server . || exit 1
elif [ "$1" == "-fl" ]; then
  print_timestamp_message "Building docker image of full-server."
  docker build -t vsock-server-full -f Dockerfile . || exit 1
else
  echo "Invalid option"
  exit 1
fi

print_docker_success_message

timestamp=$(date +%Y-%m-%d_%H:%M:%S)
echo "$timestamp - Building Enclave image"

# Build the enclave
mkdir -p $(pwd)/eif

if [ "$1" == "-pt" ]; then
    nitro-cli build-enclave --docker-uri vsock-server-portable --output-file eif/vsock_sample_server.eif || exit 1
elif [ "$1" == "-fl" ]; then
    nitro-cli build-enclave --docker-uri vsock-server-full --output-file eif/vsock_sample_server.eif || exit 1
fi

print_enclave_success_message
