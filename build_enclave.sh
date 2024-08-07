#!/bin/bash

# Build Docker image
docker build -t vsock-serverpt -f Dockerfile.server .

# Build the enclave
nitro-cli build-enclave --docker-uri vsock-serverpt --output-file vsock_sample_server.eif
