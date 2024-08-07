#!/bin/bash

function print_colored_message() {
  local message="$1"
  local color_code="$2"
  echo -e "\033[${color_code}m${message}\033[0m"
}

function remove_files_and_images() {
  print_colored_message "Removing files from eif directory..." "\033[1;32m"
  rm -rf eif/*

  print_colored_message "Removing files from bin directory..." "\033[1;32m"
  rm -rf bin/*

  print_colored_message "Removing Docker images..." "\033[1;32m"
  docker images | grep "vsock-server" | awk '{print $3}' | xargs docker rmi -f

  print_colored_message "Cleanup complete." "\033[1;32m"
}

if [ $# -gt 0 ]; then
  print_colored_message "This script does not accept any arguments." "\033[1;31m"
  exit 1
fi

remove_files_and_images
