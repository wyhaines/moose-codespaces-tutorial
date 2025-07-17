#!/bin/bash

# This entrypoint is used when building a custom Docker image
# It ensures the environment is properly set up

# If we're running as root, switch to vscode user
if [ "$(id -u)" = "0" ]; then
    # Ensure the vscode user owns the workspace
    chown -R vscode:vscode /workspace
    
    # Switch to vscode user
    exec su vscode -c "$0 $@"
fi

# Source bashrc to get PATH updates
source ~/.bashrc

# Verify Moose CLI is available
if ! command -v moose-cli &> /dev/null; then
    echo "⚠️  Moose CLI not found in PATH, installing..."
    npm install -g @514labs/moose-cli@latest
fi

# Execute the command passed to the container
exec "$@"