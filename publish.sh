#!/bin/bash

# ESP32S3DMX Library - Git Publishing Script
# This script prepares and publishes the library to GitHub

set -e  # Exit on error

echo "ESP32S3DMX Library - Git Publishing Script"
echo "=========================================="

# Configuration
GITHUB_USERNAME="yourusername"
GITHUB_REPO="ESP32S3DMX"
DEFAULT_BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "library.properties" ]; then
    print_error "This script must be run from the ESP32S3DMX library root directory"
    exit 1
fi

# Clean up development files
print_status "Cleaning up development files..."

# Remove development files if they exist
[ -f "DEVELOPMENT_STATUS.md" ] && rm -f "DEVELOPMENT_STATUS.md" && echo "  - Removed DEVELOPMENT_STATUS.md"
[ -f "PORTING_PLAN.md" ] && rm -f "PORTING_PLAN.md" && echo "  - Removed PORTING_PLAN.md"
[ -d "test" ] && rm -rf "test" && echo "  - Removed test directory"

# Remove extra example directories
for dir in examples/*/; do
    dirname=$(basename "$dir")
    if [[ "$dirname" != "BasicReceive" && "$dirname" != "ChannelMonitor" && "$dirname" != "ChannelViewer" ]]; then
        rm -rf "$dir"
        echo "  - Removed examples/$dirname"
    fi
done

print_status "Cleanup complete"

# Initialize git if needed
if [ ! -d ".git" ]; then
    print_status "Initializing git repository..."
    git init
    git branch -M $DEFAULT_BRANCH
else
    print_warning "Git repository already exists"
fi

# Create/update .gitattributes for consistent line endings
cat > .gitattributes << EOF
# Auto detect text files and perform LF normalization
* text=auto

# Force LF for these files
*.ino text eol=lf
*.cpp text eol=lf
*.h text eol=lf
*.md text eol=lf
*.txt text eol=lf
*.yml text eol=lf

# Binary files
*.png binary
*.jpg binary
*.pdf binary
EOF
print_status "Created .gitattributes"

# Update library.properties with your information
print_warning "Please update library.properties with your information:"
echo "  - author=Your Name"
echo "  - maintainer=Your Name <your.email@example.com>"
echo "  - url=https://github.com/$GITHUB_USERNAME/$GITHUB_REPO"
echo ""
read -p "Press Enter after updating library.properties..."

# Add all files
print_status "Adding files to git..."
git add .

# Show status
echo ""
echo "Git Status:"
git status --short

# Commit
echo ""
read -p "Enter commit message (default: 'Initial commit - ESP32S3DMX v1.0.0'): " commit_msg
commit_msg=${commit_msg:-"Initial commit - ESP32S3DMX v1.0.0"}

git commit -m "$commit_msg"
print_status "Committed changes"

# Add remote
echo ""
echo "To complete the setup:"
echo "1. Create a new repository on GitHub: https://github.com/new"
echo "   - Name: $GITHUB_REPO"
echo "   - Description: DMX512 receiver library for ESP32 with Arduino Core 3.0+"
echo "   - Public repository"
echo "   - Do NOT initialize with README, license, or .gitignore"
echo ""
echo "2. After creating the repository, run these commands:"
echo ""
echo -e "${YELLOW}git remote add origin https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git${NC}"
echo -e "${YELLOW}git push -u origin $DEFAULT_BRANCH${NC}"
echo ""
echo "3. Then create a release:"
echo "   - Go to https://github.com/$GITHUB_USERNAME/$GITHUB_REPO/releases/new"
echo "   - Tag: v1.0.0"
echo "   - Title: ESP32S3DMX v1.0.0"
echo "   - Description: Copy from CHANGELOG.md"
echo ""
echo "4. Submit to Arduino Library Manager:"
echo "   - Go to https://github.com/arduino/library-registry/issues/new"
echo "   - Select 'Add library' template"
echo "   - Repository URL: https://github.com/$GITHUB_USERNAME/$GITHUB_REPO"
echo ""

# Optional: Create release automatically
read -p "Would you like to create a git tag for v1.0.0 now? (y/n): " create_tag
if [[ $create_tag == "y" || $create_tag == "Y" ]]; then
    git tag -a v1.0.0 -m "Release version 1.0.0 - Initial release"
    print_status "Created tag v1.0.0"
    echo ""
    echo "After pushing to GitHub, also run:"
    echo -e "${YELLOW}git push origin v1.0.0${NC}"
fi

print_status "Script complete!"
echo ""
echo "Next steps:"
echo "1. Update library.properties if you haven't already"
echo "2. Create the GitHub repository"
echo "3. Push the code"
echo "4. Create a release"
echo "5. Submit to Arduino Library Manager"
