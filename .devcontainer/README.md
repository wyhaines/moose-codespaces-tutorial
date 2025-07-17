# Moose Tutorial Codespace Configuration

This directory contains the configuration files for running the Moose tutorial in GitHub Codespaces.

## Files

- **devcontainer.json** - Main configuration file for the dev container
- **startup.sh** - Script that runs when the container starts to install Moose and start services
- **welcome.txt** - Welcome message displayed when users attach to the container
- **Dockerfile** - Custom Docker image for faster startup (optional)
- **entrypoint.sh** - Entrypoint script for the custom Docker image

## How it Works

1. When a Codespace is created, it uses the TypeScript Node.js base image with Docker-in-Docker support
2. The `startup.sh` script runs automatically to:
   - Install npm dependencies
   - Install Moose CLI globally via npm
   - Start the Moose dev server (all infrastructure services)
   - Wait for services to be ready
   - Generate sample data

3. VS Code automatically opens the key tutorial files
4. The welcome message is displayed in the terminal

## Using the Custom Docker Image

For faster startup times, you can build and use the custom Docker image:

1. Build the image:
   ```bash
   docker build -f .devcontainer/Dockerfile -t moose-tutorial-devcontainer .
   ```

2. Update `devcontainer.json` to use the custom image:
   ```json
   "image": "moose-tutorial-devcontainer"
   ```

## Troubleshooting

If the Moose CLI doesn't install properly:

1. Check the Codespace creation logs
2. Try running the install manually:
   ```bash
   npm install -g @514labs/moose-cli
   ```
3. Verify Docker is working:
   ```bash
   docker ps
   ```

## Tutorial Scripts

The following npm scripts are available for the tutorial:

- `npm run tutorial:start` - Start the Moose dev server
- `npm run tutorial:logs` - View streaming logs
- `npm run tutorial:generate-data` - Generate test data
- `npm run tutorial:stop` - Stop the server
- `npm run tutorial:status` - Check service status
- `npm run tutorial:query` - Query the API (requires jq)