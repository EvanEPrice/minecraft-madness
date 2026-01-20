#!/bin/bash

# Minecraft World Packaging Script
# Packages world for distribution

WORLD_NAME="${1:-world}"
OUTPUT_NAME="${2:-MM2025}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="${OUTPUT_NAME}_${TIMESTAMP}.zip"
TEMP_DIR="/tmp/minecraft_package_$$"

echo "=== Minecraft World Packaging Script ==="
echo "World to package: ${WORLD_NAME}"
echo "Output name: ${OUTPUT_NAME}"
echo ""

# Check if running as root/sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo"
    exit 1
fi

# Navigate to server directory
cd /opt/minecraft/server || exit 1

# Check if world exists
if [ ! -d "${WORLD_NAME}" ]; then
    echo "Error: World directory '${WORLD_NAME}' not found!"
    exit 1
fi

echo "Sending save-all command to server..."
screen -p 0 -S minecraft -X eval 'stuff "save-all\015"'
sleep 5

echo "Disabling auto-save temporarily..."
screen -p 0 -S minecraft -X eval 'stuff "save-off\015"'
sleep 2

echo "Creating temporary packaging directory..."
mkdir -p "${TEMP_DIR}"

echo "Copying world data..."
cp -r "${WORLD_NAME}" "${TEMP_DIR}/"

echo "Copying server configuration files..."
cp server.properties "${TEMP_DIR}/" 2>/dev/null || echo "Note: server.properties not found"
cp ops.json "${TEMP_DIR}/" 2>/dev/null || echo "Note: ops.json not found"
cp whitelist.json "${TEMP_DIR}/" 2>/dev/null || echo "Note: whitelist.json not found"

# Create a README
cat > "${TEMP_DIR}/README.txt" << READMEEOF
MinecraftMadness World Download
================================

World Name: ${OUTPUT_NAME}
Minecraft Version: 1.21.11
Packaged: ${TIMESTAMP}

Installation Instructions:
--------------------------
1. Stop your Minecraft server
2. Extract this archive to your server directory
3. The world folder should be placed in your server root
4. Update server.properties to use level-name=${WORLD_NAME}
5. Start your server

Files Included:
---------------
- ${WORLD_NAME}/ - World directory with all region data
- server.properties - Server configuration (reference)
- ops.json - Operator list (if applicable)
- whitelist.json - Whitelist (if applicable)

Note: You may want to use your own server.properties settings.
The included file is for reference only.

Enjoy!
READMEEOF

echo "Creating zip archive..."
cd "${TEMP_DIR}" || exit 1
zip -r "/opt/minecraft/${OUTPUT_FILE}" .

echo "Re-enabling auto-save..."
screen -p 0 -S minecraft -X eval 'stuff "save-on\015"'

echo "Cleaning up temporary files..."
rm -rf "${TEMP_DIR}"

echo ""
echo "=== Packaging Complete ==="
echo "Output file: /opt/minecraft/${OUTPUT_FILE}"
echo "File size: $(du -h /opt/minecraft/${OUTPUT_FILE} | cut -f1)"
echo ""
echo "To download from server:"
echo "  scp -i your-key.pem ubuntu@your-server:/opt/minecraft/${OUTPUT_FILE} ."
echo ""
echo "To unpack on another server:"
echo "  unzip ${OUTPUT_FILE} -d /opt/minecraft/server/"
echo "  chown -R minecraft:minecraft /opt/minecraft/server/${WORLD_NAME}"
