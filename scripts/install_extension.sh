#!/bin/sh
set -e

install_extension() {
  echo "Installing $1..."
  shift
  if ! "$@"; then
    echo "WARNING: Failed to install, continuing anyway"
    return 1
  fi
  echo "Extension installed successfully"
  return 0
}