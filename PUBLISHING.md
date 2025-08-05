# Publishing ESP32S3DMX to GitHub

This directory contains scripts to help you publish the library to GitHub.

## Scripts

### publish.sh
Interactive script that guides you through the entire process:
- Cleans up development files
- Initializes git repository
- Helps you update library metadata
- Provides step-by-step instructions
- Creates git tag for release

Usage:
```bash
chmod +x publish.sh
./publish.sh
```

### quick-publish.sh
Automated script for experienced users:
- Automatically cleans up files
- Updates library.properties
- Creates initial commit
- Tags release v1.0.0

Before running, edit the script and update:
- `GITHUB_USERNAME`
- `AUTHOR_NAME`
- `AUTHOR_EMAIL`

Usage:
```bash
chmod +x quick-publish.sh
./quick-publish.sh
```

## Manual Steps After Running Scripts

1. **Create GitHub Repository**
   - Go to https://github.com/new
   - Name: ESP32S3DMX
   - Description: DMX512 receiver library for ESP32 with Arduino Core 3.0+
   - Public repository
   - Do NOT initialize with any files

2. **Push to GitHub**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/ESP32S3DMX.git
   git push -u origin main
   git push origin v1.0.0
   ```

3. **Submit to Arduino Library Manager**
   - Go to https://github.com/arduino/library-registry/issues/new
   - Choose "Add library" template
   - Provide repository URL

## Pre-flight Checklist

Before publishing, ensure:
- [ ] library.properties has your correct information
- [ ] README.md has correct GitHub URLs
- [ ] All examples compile without errors
- [ ] Documentation is complete
- [ ] No sensitive information in code

## Making Scripts Executable

```bash
chmod +x publish.sh quick-publish.sh
```
