#!/bin/bash

# ESP32S3DMX Library - Quick Git Update
# For quick commits and pushes

set -e

echo "Quick Git Update"
echo "================"

# Add all changes
git add .

# Show status
echo "Changes to commit:"
git status --short

# Get commit message
echo ""
echo "Commit message (Enter for 'Update library'):"
read -r msg
msg=${msg:-"Update library"}

# Commit and push
git commit -m "$msg"
git push

echo "✓ Done!"
