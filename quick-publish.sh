#!/bin/bash

# ESP32S3DMX Library - Quick Publish Script
# For experienced users who want a faster process

set -e

# Configuration - UPDATE THESE!
GITHUB_USERNAME="TimRosener"
GITHUB_REPO="ESP32S3DMX"
AUTHOR_NAME="Tim Rosener"
AUTHOR_EMAIL="tim@rosener.com"

echo "ESP32S3DMX Quick Publish"
echo "======================="

# Clean up
echo "Cleaning up..."
rm -f DEVELOPMENT_STATUS.md PORTING_PLAN.md prompt.md
rm -rf test
find examples -maxdepth 1 -type d ! -name examples ! -name BasicReceive ! -name ChannelMonitor ! -name ChannelViewer -exec rm -rf {} +

# Update library.properties
echo "Updating library.properties..."
sed -i.bak "s/author=.*/author=$AUTHOR_NAME/" library.properties
sed -i.bak "s/maintainer=.*/maintainer=$AUTHOR_NAME <$AUTHOR_EMAIL>/" library.properties
sed -i.bak "s|url=.*|url=https://github.com/$GITHUB_USERNAME/$GITHUB_REPO|" library.properties
rm -f library.properties.bak

# Initialize git
git init
git add .
git commit -m "Initial commit - ESP32S3DMX v1.0.0

Professional DMX512 receiver library for ESP32 with Arduino Core 3.0+ support.

Features:
- Full 512 channel support
- Automatic break detection  
- ESP32/S2/S3 compatibility
- Thread-safe operation
- Comprehensive examples
- Professional documentation"

# Tag release
git tag -a v1.0.0 -m "Release version 1.0.0

Initial release of ESP32S3DMX library.

Features:
- DMX512 receiver implementation
- Arduino Core 3.0+ compatibility
- Support for ESP32, ESP32-S2, and ESP32-S3
- Automatic UART break detection
- Three comprehensive examples
- Full API documentation

See CHANGELOG.md for details."

echo ""
echo "✓ Repository prepared and tagged"
echo ""
echo "Next steps:"
echo "1. Create repo at: https://github.com/new"
echo "2. Run:"
echo "   git remote add origin https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git"
echo "   git push -u origin main"
echo "   git push origin v1.0.0"
echo ""
echo "3. The GitHub release will be created automatically from the tag"
