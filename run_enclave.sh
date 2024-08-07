#!/bin/bash

function print_usage() {
  echo "Usage: $0 [-c <cid>] [-n <enclave-name>] [-d]"
  echo "  -c: specify enclave CID"
  echo "  -d: enable debug mode"
}

function run_enclave() {
  local debug_mode=""
  local enclave_cid=""
  local enclave_name=""

  while getopts ":dc:n" opt; do
    case $opt in
      d)
        debug_mode="--debug-mode"
        ;;
      c)
        enclave_cid="--enclave-cid $OPTARG"
        ;;
      n)
        enclave_name="--enclave-name $OPTARG"
        ;;
      \?)
        print_usage
        exit 1
        ;;
    esac
  done

  nitro-cli run-enclave \
    --eif-path $(pwd)/eif/vsock_sample_server.eif \
    --cpu-count 1 \
    --memory 3700 \
    $debug_mode \
    $enclave_cid \
    $enclave_name  
}

if [ $# -eq 0 ]; then
  print_usage
  exit 1
fi

run_enclave "$@"

nitro-cli console --enclave-name vsock_sample_server