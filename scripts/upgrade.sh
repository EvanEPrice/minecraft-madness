#!/bin/bash

# Minecraft Server Update Script - Version 1.21.11 (Mounts of Mayhem)
# Run as root or with sudo

echo "Stopping Minecraft server..."
systemctl stop minecraft.service

echo "Backing up current server.jar..."
cd /opt/minecraft/server
cp server.jar server.jar.backup.$(date +%Y%m%d_%H%M%S)

echo "Downloading Minecraft 1.21.11..."
wget -O server.jar https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar

echo "Setting proper ownership..."
chown minecraft:minecraft server.jar

echo "Starting Minecraft server..."
systemctl start minecraft.service

echo "Update complete! Check server status with: systemctl status minecraft.service"