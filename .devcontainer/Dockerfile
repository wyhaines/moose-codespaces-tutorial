FROM mcr.microsoft.com/devcontainers/typescript-node:1-20-bullseye

# Install additional tools that might be useful for the tutorial
RUN apt-get update && apt-get install -y \
    jq \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Pre-install Moose CLI globally
RUN npm install -g @514labs/moose-cli@latest

# Create workspace directory
WORKDIR /workspace

# Pre-install dependencies to speed up startup
COPY package*.json ./
RUN npm install

# Create entrypoint script
COPY .devcontainer/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set up non-root user (vscode)
USER vscode

# Ensure Moose CLI is in PATH for the vscode user
RUN echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc

# Switch back to root for the entrypoint
USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]