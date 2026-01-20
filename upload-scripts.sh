#!/bin/bash
# Upload scripts to the Minecraft server

set -e

SSH_KEY="$HOME/LightsailDefaultKey-us-east-1.pem"
SSH_USER="ubuntu"
SSH_HOST="52.6.156.128"
SSH_OPTS="-i $SSH_KEY"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_DIR="~/scripts"

echo "Creating remote directory if needed..."
ssh $SSH_OPTS "$SSH_USER@$SSH_HOST" "mkdir -p $REMOTE_DIR"

echo "Uploading scripts..."
scp $SSH_OPTS "$SCRIPT_DIR/package-world.sh" "$SCRIPT_DIR/upgrade.sh" "$SSH_USER@$SSH_HOST:$REMOTE_DIR/"

echo "Setting executable permissions..."
ssh $SSH_OPTS "$SSH_USER@$SSH_HOST" "chmod 755 $REMOTE_DIR/*.sh"

echo "Done! Scripts uploaded to $REMOTE_DIR on $SSH_HOST"