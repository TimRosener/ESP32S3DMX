#!/bin/bash

# ESP32S3DMX Library - Git Update Script
# Updates existing git repository with latest changes

set -e  # Exit on error

echo "ESP32S3DMX Library - Git Update Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not a git repository! Run this from the ESP32S3DMX directory"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "library.properties" ]; then
    print_error "This doesn't appear to be the ESP32S3DMX library directory"
    exit 1
fi

print_status "Found ESP32S3DMX library repository"

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
print_info "Current branch: $CURRENT_BRANCH"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes:"
    git status --short
    echo ""
    read -p "Do you want to commit these changes? (y/n): " commit_changes
    
    if [[ $commit_changes == "y" || $commit_changes == "Y" ]]; then
        # Stage all changes
        git add .
        
        # Show what will be committed
        echo ""
        echo "Changes to be committed:"
        git diff --staged --stat
        echo ""
        
        # Get commit message
        echo "Enter commit message (or press Enter for default):"
        read -p "> " commit_msg
        
        if [ -z "$commit_msg" ]; then
            # Generate default commit message based on changes
            if git diff --staged --name-only | grep -q "README.md"; then
                commit_msg="docs: add thread safety documentation and dual licensing"
            else
                commit_msg="chore: update library files"
            fi
        fi
        
        # Commit
        git commit -m "$commit_msg"
        print_status "Changes committed"
    else
        print_warning "Skipping commit - changes remain unstaged"
    fi
fi

# Fetch latest from remote
print_info "Fetching latest from remote..."
git fetch origin

# Check if we're behind remote
BEHIND=$(git rev-list HEAD..origin/$CURRENT_BRANCH --count 2>/dev/null || echo "0")
if [ "$BEHIND" -gt 0 ]; then
    print_warning "Your branch is behind origin/$CURRENT_BRANCH by $BEHIND commit(s)"
    read -p "Pull latest changes? (y/n): " pull_changes
    if [[ $pull_changes == "y" || $pull_changes == "Y" ]]; then
        git pull origin $CURRENT_BRANCH
        print_status "Pulled latest changes"
    fi
fi

# Push changes
AHEAD=$(git rev-list origin/$CURRENT_BRANCH..HEAD --count 2>/dev/null || echo "0")
if [ "$AHEAD" -gt 0 ]; then
    print_info "You have $AHEAD commit(s) to push"
    read -p "Push to origin/$CURRENT_BRANCH? (y/n): " push_changes
    
    if [[ $push_changes == "y" || $push_changes == "Y" ]]; then
        git push origin $CURRENT_BRANCH
        print_status "Pushed to origin/$CURRENT_BRANCH"
    fi
else
    print_info "Already up to date with origin/$CURRENT_BRANCH"
fi

# Check if we should create a new release
echo ""
read -p "Create a new release tag? (y/n): " create_release

if [[ $create_release == "y" || $create_release == "Y" ]]; then
    # Show existing tags
    echo ""
    echo "Existing tags:"
    git tag -l "v*" | tail -5
    
    # Get current version from library.properties
    CURRENT_VERSION=$(grep "version=" library.properties | cut -d'=' -f2)
    print_info "Current version in library.properties: $CURRENT_VERSION"
    
    # Suggest next version
    echo ""
    echo "Enter new version number (e.g., 1.1.0):"
    read -p "> " NEW_VERSION
    
    if [ -z "$NEW_VERSION" ]; then
        print_error "Version number required"
        exit 1
    fi
    
    # Update library.properties
    sed -i.bak "s/version=.*/version=$NEW_VERSION/" library.properties
    rm -f library.properties.bak
    
    # Update version in header file if it exists
    if grep -q "VERSION" src/ESP32S3DMX.h; then
        sed -i.bak "s/VERSION \".*\"/VERSION \"$NEW_VERSION\"/" src/ESP32S3DMX.h
        rm -f src/ESP32S3DMX.h.bak
    fi
    
    # Commit version bump
    git add library.properties src/ESP32S3DMX.h
    git commit -m "chore: bump version to $NEW_VERSION"
    
    # Create release notes
    echo ""
    echo "Enter release notes (press Ctrl+D when done):"
    RELEASE_NOTES=$(cat)
    
    # Create annotated tag
    git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION

$RELEASE_NOTES"
    
    print_status "Created tag v$NEW_VERSION"
    
    # Push with tags
    read -p "Push tag to origin? (y/n): " push_tag
    if [[ $push_tag == "y" || $push_tag == "Y" ]]; then
        git push origin $CURRENT_BRANCH
        git push origin "v$NEW_VERSION"
        print_status "Pushed tag v$NEW_VERSION"
        
        echo ""
        print_info "Next steps:"
        echo "1. Go to https://github.com/yourusername/ESP32S3DMX/releases/new"
        echo "2. Select tag: v$NEW_VERSION"
        echo "3. Title: ESP32S3DMX v$NEW_VERSION"
        echo "4. Copy release notes from CHANGELOG.md"
        echo "5. Publish release"
    fi
fi

# Summary
echo ""
echo "======================================"
print_status "Git update complete!"
echo ""

# Show current status
echo "Repository status:"
git status --short --branch
echo ""

# Show recent commits
echo "Recent commits:"
git log --oneline -5
echo ""

# Reminder about Arduino Library Manager
if git tag -l "v*" | grep -q "v"; then
    print_info "Remember to submit updates to Arduino Library Manager if needed"
    echo "   https://github.com/arduino/library-registry"
fi
