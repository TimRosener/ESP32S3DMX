#!/bin/bash

# Arduino Library Creator Script
# Creates a professional library structure with all documentation templates

set -e

echo "Arduino Library Creator"
echo "======================"
echo ""

# Get library information
read -p "Library name (e.g., MyAwesomeLib): " LIB_NAME
read -p "Your name: " AUTHOR_NAME
read -p "Your email: " AUTHOR_EMAIL
read -p "Brief description (one line): " BRIEF_DESC
read -p "Category (Communication/Sensors/Display/etc.): " CATEGORY
read -p "GitHub username: " GITHUB_USER

# Validate input
if [ -z "$LIB_NAME" ]; then
    echo "Error: Library name is required!"
    exit 1
fi

# Convert library name to uppercase for header guards
LIB_NAME_UPPER=$(echo "$LIB_NAME" | tr '[:lower:]' '[:upper:]')

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$LIB_NAME"/{src,examples,docs,.github/workflows}
cd "$LIB_NAME"

# Create examples subdirectories
mkdir -p examples/{BasicExample,AdvancedExample,InteractiveExample}

# Create library.properties
echo "Creating library.properties..."
cat > library.properties << EOF
name=$LIB_NAME
version=0.1.0
author=$AUTHOR_NAME
maintainer=$AUTHOR_NAME <$AUTHOR_EMAIL>
sentence=$BRIEF_DESC
paragraph=A comprehensive library that provides $BRIEF_DESC. Supports multiple Arduino-compatible boards and includes detailed examples and documentation.
category=$CATEGORY
url=https://github.com/$GITHUB_USER/$LIB_NAME
architectures=*
includes=${LIB_NAME}.h
EOF

# Create keywords.txt
echo "Creating keywords.txt..."
cat > keywords.txt << EOF
#######################################
# Syntax Coloring Map for $LIB_NAME
#######################################

#######################################
# Datatypes (KEYWORD1)
#######################################

$LIB_NAME	KEYWORD1

#######################################
# Methods and Functions (KEYWORD2)
#######################################

begin	KEYWORD2
end	KEYWORD2
process	KEYWORD2
isConnected	KEYWORD2
getStatus	KEYWORD2
setConfig	KEYWORD2

#######################################
# Constants (LITERAL1)
#######################################

${LIB_NAME_UPPER}_VERSION	LITERAL1
${LIB_NAME_UPPER}_DEFAULT	LITERAL1
EOF

# Create main header file
echo "Creating src/${LIB_NAME}.h..."
cat > src/${LIB_NAME}.h << EOF
/**
 * @file ${LIB_NAME}.h
 * @brief $BRIEF_DESC
 * @version 0.1.0
 * @date $(date +%Y-%m-%d)
 * @author $AUTHOR_NAME
 * @copyright Copyright (c) $(date +%Y) $AUTHOR_NAME. Licensed under MIT.
 * 
 * @see https://github.com/$GITHUB_USER/$LIB_NAME
 */

#ifndef ${LIB_NAME_UPPER}_H
#define ${LIB_NAME_UPPER}_H

#include <Arduino.h>

// Library version
#define ${LIB_NAME_UPPER}_VERSION "0.1.0"

// Default configuration values
#define ${LIB_NAME_UPPER}_DEFAULT_PIN 13
#define ${LIB_NAME_UPPER}_DEFAULT_TIMEOUT 1000

/**
 * @class $LIB_NAME
 * @brief Main class for $LIB_NAME library
 * 
 * This class provides the main functionality for $BRIEF_DESC.
 * 
 * @code
 * $LIB_NAME myInstance;
 * 
 * void setup() {
 *     myInstance.begin();
 * }
 * 
 * void loop() {
 *     myInstance.process();
 * }
 * @endcode
 */
class $LIB_NAME {
public:
    /**
     * @brief Construct a new $LIB_NAME object
     */
    $LIB_NAME();
    
    /**
     * @brief Initialize the library
     * 
     * @param pin Pin number to use (default: ${LIB_NAME_UPPER}_DEFAULT_PIN)
     * @return true if initialization successful
     * @return false if initialization failed
     */
    bool begin(uint8_t pin = ${LIB_NAME_UPPER}_DEFAULT_PIN);
    
    /**
     * @brief Stop the library and release resources
     */
    void end();
    
    /**
     * @brief Main processing function
     * 
     * Call this regularly in your loop() function.
     */
    void process();
    
    /**
     * @brief Check if connected/initialized
     * 
     * @return true if connected
     * @return false if not connected
     */
    bool isConnected() const;
    
    /**
     * @brief Get current status
     * 
     * @return uint8_t Status code
     */
    uint8_t getStatus() const;
    
    /**
     * @brief Set configuration
     * 
     * @param config Configuration value
     */
    void setConfig(uint8_t config);

private:
    uint8_t _pin;           ///< Pin number in use
    bool _initialized;      ///< Initialization state
    uint8_t _status;        ///< Current status
    uint8_t _config;        ///< Configuration value
    uint32_t _lastUpdate;   ///< Last update timestamp
};

#endif // ${LIB_NAME_UPPER}_H
EOF

# Create implementation file
echo "Creating src/${LIB_NAME}.cpp..."
cat > src/${LIB_NAME}.cpp << EOF
/**
 * @file ${LIB_NAME}.cpp
 * @brief Implementation of $LIB_NAME library
 */

#include "${LIB_NAME}.h"

$LIB_NAME::$LIB_NAME() : 
    _pin(${LIB_NAME_UPPER}_DEFAULT_PIN),
    _initialized(false),
    _status(0),
    _config(0),
    _lastUpdate(0) {
    // Constructor
}

bool $LIB_NAME::begin(uint8_t pin) {
    _pin = pin;
    
    // Initialize hardware
    pinMode(_pin, OUTPUT);
    digitalWrite(_pin, LOW);
    
    _initialized = true;
    _lastUpdate = millis();
    
    return true;
}

void $LIB_NAME::end() {
    if (_initialized) {
        // Cleanup
        digitalWrite(_pin, LOW);
        _initialized = false;
    }
}

void $LIB_NAME::process() {
    if (!_initialized) return;
    
    // Main processing logic
    uint32_t now = millis();
    if (now - _lastUpdate >= 1000) {
        _lastUpdate = now;
        // Do something every second
        digitalWrite(_pin, !digitalRead(_pin));
    }
}

bool $LIB_NAME::isConnected() const {
    return _initialized;
}

uint8_t $LIB_NAME::getStatus() const {
    return _status;
}

void $LIB_NAME::setConfig(uint8_t config) {
    _config = config;
}
EOF

# Create README.md
echo "Creating README.md..."
cat > README.md << EOF
# $LIB_NAME

[![Arduino](https://img.shields.io/badge/Arduino-Library-blue)](https://www.arduino.cc/reference/en/libraries/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/$GITHUB_USER/$LIB_NAME)](https://github.com/$GITHUB_USER/$LIB_NAME/releases)

$BRIEF_DESC

## Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Documentation](#api-documentation)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3
- 🚧 Feature in development
- ❌ Not supported feature

## Requirements

### Software
- Arduino IDE 1.8.13+ or PlatformIO
- No external dependencies

### Hardware
- Any Arduino-compatible board
- Additional components as needed

## Installation

### Arduino Library Manager
1. Open Arduino IDE
2. Go to **Sketch** → **Include Library** → **Manage Libraries**
3. Search for "$LIB_NAME"
4. Click **Install**

### Manual Installation
\`\`\`bash
cd ~/Documents/Arduino/libraries
git clone https://github.com/$GITHUB_USER/$LIB_NAME.git
\`\`\`

## Quick Start

\`\`\`cpp
#include <$LIB_NAME.h>

$LIB_NAME myLibrary;

void setup() {
    Serial.begin(115200);
    
    if (myLibrary.begin()) {
        Serial.println("$LIB_NAME initialized!");
    }
}

void loop() {
    myLibrary.process();
    delay(100);
}
\`\`\`

## API Documentation

See the [API Documentation](docs/API.md) for detailed information about all available methods.

## Examples

- **[BasicExample](examples/BasicExample)** - Simple usage demonstration
- **[AdvancedExample](examples/AdvancedExample)** - Advanced features
- **[InteractiveExample](examples/InteractiveExample)** - Interactive Serial Monitor control

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This library is licensed under the [MIT License](LICENSE).

---

**Need help?** Open an [issue](https://github.com/$GITHUB_USER/$LIB_NAME/issues) on GitHub.
EOF

# Create CHANGELOG.md
echo "Creating CHANGELOG.md..."
cat > CHANGELOG.md << EOF
# Changelog

All notable changes to $LIB_NAME will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial development

## [0.1.0] - $(date +%Y-%m-%d)
### Added
- Initial release
- Basic functionality
- Three examples
- Documentation

[unreleased]: https://github.com/$GITHUB_USER/$LIB_NAME/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/$GITHUB_USER/$LIB_NAME/releases/tag/v0.1.0
EOF

# Create CONTRIBUTING.md
echo "Creating CONTRIBUTING.md..."
cat > CONTRIBUTING.md << EOF
# Contributing to $LIB_NAME

Thank you for your interest in contributing to $LIB_NAME!

## How to Contribute

### Reporting Bugs
Before creating bug reports, please check existing issues. When you create a bug report, include:
- Clear and descriptive title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Code samples
- Hardware/software details

### Suggesting Enhancements
Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:
- Use a clear and descriptive title
- Provide detailed description
- Explain why this enhancement would be useful
- List any alternatives considered

### Pull Requests
1. Fork the repository
2. Create your feature branch (\`git checkout -b feature/AmazingFeature\`)
3. Commit your changes (\`git commit -m 'Add AmazingFeature'\`)
4. Push to the branch (\`git push origin feature/AmazingFeature\`)
5. Open a Pull Request

## Code Style
- Use 4 spaces for indentation
- Follow Arduino style guide
- Comment your code
- Update documentation

## Testing
- Test your changes on actual hardware
- Ensure all examples still work
- Add new examples if adding features

## License
By contributing, you agree that your contributions will be licensed under the MIT License.
EOF

# Create LICENSE
echo "Creating LICENSE..."
cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) $AUTHOR_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create .gitignore
echo "Creating .gitignore..."
cat > .gitignore << EOF
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Development
*.swp
*.bak
*~
.vscode/
.idea/

# Build files
build/
.pio/
.pioenvs/
.piolibdeps/

# Python
__pycache__/
*.py[cod]
EOF

# Create .gitattributes
echo "Creating .gitattributes..."
cat > .gitattributes << EOF
# Auto detect text files
* text=auto

# Force LF for source files
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

# Create BasicExample
echo "Creating examples/BasicExample..."
cat > examples/BasicExample/BasicExample.ino << EOF
/*
  BasicExample.ino - Basic usage of $LIB_NAME
  
  This example demonstrates the basic functionality of the $LIB_NAME library.
  
  The circuit:
  - LED connected to pin 13 (or built-in LED)
  
  Created: $(date +%Y-%m-%d)
  By: $AUTHOR_NAME
  
  This example is in the public domain.
*/

#include <$LIB_NAME.h>

// Create library instance
$LIB_NAME myLibrary;

void setup() {
    // Initialize serial communication
    Serial.begin(115200);
    while (!Serial && millis() < 5000) {
        ; // Wait for serial port
    }
    
    Serial.println("$LIB_NAME Basic Example");
    Serial.println("======================");
    
    // Initialize the library
    if (myLibrary.begin()) {
        Serial.println("Library initialized successfully!");
    } else {
        Serial.println("Failed to initialize library!");
        while (1); // Halt
    }
}

void loop() {
    // Process library functions
    myLibrary.process();
    
    // Check status every second
    static unsigned long lastCheck = 0;
    if (millis() - lastCheck >= 1000) {
        lastCheck = millis();
        
        Serial.print("Status: ");
        Serial.print(myLibrary.getStatus());
        Serial.print(" | Connected: ");
        Serial.println(myLibrary.isConnected() ? "Yes" : "No");
    }
}
EOF

# Create AdvancedExample
echo "Creating examples/AdvancedExample..."
cat > examples/AdvancedExample/AdvancedExample.ino << EOF
/*
  AdvancedExample.ino - Advanced features of $LIB_NAME
  
  This example demonstrates advanced functionality including:
  - Custom configuration
  - Error handling
  - Performance optimization
  
  Created: $(date +%Y-%m-%d)
  By: $AUTHOR_NAME
*/

#include <$LIB_NAME.h>

$LIB_NAME myLibrary;

// Configuration
const uint8_t CUSTOM_PIN = 10;
const uint8_t CUSTOM_CONFIG = 0x42;

void setup() {
    Serial.begin(115200);
    while (!Serial && millis() < 5000);
    
    Serial.println("$LIB_NAME Advanced Example");
    Serial.println("=========================");
    
    // Initialize with custom pin
    if (!myLibrary.begin(CUSTOM_PIN)) {
        Serial.println("Initialization failed!");
        while (1);
    }
    
    // Apply custom configuration
    myLibrary.setConfig(CUSTOM_CONFIG);
    Serial.println("Custom configuration applied");
}

void loop() {
    // Advanced processing
    myLibrary.process();
    
    // Monitor performance
    static unsigned long updates = 0;
    static unsigned long lastReport = 0;
    
    updates++;
    
    if (millis() - lastReport >= 5000) {
        float rate = updates / 5.0;
        Serial.print("Update rate: ");
        Serial.print(rate);
        Serial.println(" Hz");
        
        updates = 0;
        lastReport = millis();
    }
}
EOF

# Create InteractiveExample
echo "Creating examples/InteractiveExample..."
cat > examples/InteractiveExample/InteractiveExample.ino << EOF
/*
  InteractiveExample.ino - Interactive control via Serial Monitor
  
  This example allows you to control the library through
  Serial Monitor commands.
  
  Commands:
  - 's' : Show status
  - 'r' : Reset/restart
  - 'c' : Configure
  - 'h' : Show help
  
  Created: $(date +%Y-%m-%d)
  By: $AUTHOR_NAME
*/

#include <$LIB_NAME.h>

$LIB_NAME myLibrary;

void printHelp() {
    Serial.println("\nAvailable commands:");
    Serial.println("  s - Show status");
    Serial.println("  r - Reset/restart");
    Serial.println("  c - Configure");
    Serial.println("  h - Show this help");
    Serial.println();
}

void setup() {
    Serial.begin(115200);
    while (!Serial && millis() < 5000);
    
    Serial.println("$LIB_NAME Interactive Example");
    Serial.println("=============================");
    
    if (myLibrary.begin()) {
        Serial.println("Library initialized!");
    } else {
        Serial.println("Initialization failed!");
        while (1);
    }
    
    printHelp();
}

void loop() {
    // Process library
    myLibrary.process();
    
    // Check for serial commands
    if (Serial.available()) {
        char cmd = Serial.read();
        
        switch (cmd) {
            case 's':
                Serial.println("\n--- Status ---");
                Serial.print("Connected: ");
                Serial.println(myLibrary.isConnected() ? "Yes" : "No");
                Serial.print("Status code: ");
                Serial.println(myLibrary.getStatus());
                break;
                
            case 'r':
                Serial.println("\nRestarting...");
                myLibrary.end();
                delay(100);
                if (myLibrary.begin()) {
                    Serial.println("Restarted successfully!");
                }
                break;
                
            case 'c':
                Serial.println("\nEnter config value (0-255):");
                while (!Serial.available());
                uint8_t config = Serial.parseInt();
                myLibrary.setConfig(config);
                Serial.print("Configuration set to: ");
                Serial.println(config);
                break;
                
            case 'h':
                printHelp();
                break;
                
            case '\n':
            case '\r':
                break;
                
            default:
                Serial.print("Unknown command: ");
                Serial.println(cmd);
                printHelp();
        }
    }
}
EOF

# Create examples README
echo "Creating examples/README.md..."
cat > examples/README.md << EOF
# $LIB_NAME Examples

This directory contains example sketches demonstrating how to use the $LIB_NAME library.

## Examples

### BasicExample
Demonstrates basic usage including:
- Library initialization
- Main processing loop
- Status checking

### AdvancedExample
Shows advanced features including:
- Custom pin configuration
- Performance monitoring
- Error handling

### InteractiveExample
Interactive Serial Monitor control:
- Send commands via Serial Monitor
- Real-time configuration
- Status monitoring

## Hardware Setup

All examples assume:
- Arduino-compatible board
- LED on pin 13 (or custom pin)
- Serial Monitor at 115200 baud

## Running the Examples

1. Open the example in Arduino IDE
2. Select your board and port
3. Upload the sketch
4. Open Serial Monitor (115200 baud)
5. Follow the prompts

## Customization

Each example can be customized by modifying the pin assignments and configuration values at the top of the sketch.
EOF

# Create API documentation
echo "Creating docs/API.md..."
cat > docs/API.md << EOF
# $LIB_NAME API Documentation

Complete API reference for the $LIB_NAME library.

## Table of Contents
- [Class: $LIB_NAME](#class-$LIB_NAME)
  - [Constructor](#constructor)
  - [Methods](#methods)
  - [Constants](#constants)

## Class: $LIB_NAME

### Constructor

\`\`\`cpp
$LIB_NAME()
\`\`\`

Creates a new instance of the $LIB_NAME class.

**Example:**
\`\`\`cpp
$LIB_NAME myInstance;
\`\`\`

### Methods

#### begin()

\`\`\`cpp
bool begin(uint8_t pin = ${LIB_NAME_UPPER}_DEFAULT_PIN)
\`\`\`

Initializes the library with the specified pin.

**Parameters:**
- \`pin\`: GPIO pin number (default: 13)

**Returns:**
- \`true\`: Initialization successful
- \`false\`: Initialization failed

**Example:**
\`\`\`cpp
if (myInstance.begin(10)) {
    Serial.println("Initialized on pin 10");
}
\`\`\`

#### end()

\`\`\`cpp
void end()
\`\`\`

Stops the library and releases resources.

#### process()

\`\`\`cpp
void process()
\`\`\`

Main processing function. Call this regularly in your \`loop()\`.

**Example:**
\`\`\`cpp
void loop() {
    myInstance.process();
    delay(10);
}
\`\`\`

#### isConnected()

\`\`\`cpp
bool isConnected() const
\`\`\`

Checks if the library is properly initialized and connected.

**Returns:**
- \`true\`: Connected and ready
- \`false\`: Not connected

#### getStatus()

\`\`\`cpp
uint8_t getStatus() const
\`\`\`

Gets the current status code.

**Returns:**
- Status code (0-255)

#### setConfig()

\`\`\`cpp
void setConfig(uint8_t config)
\`\`\`

Sets the configuration value.

**Parameters:**
- \`config\`: Configuration value (0-255)

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| \`${LIB_NAME_UPPER}_VERSION\` | "0.1.0" | Library version string |
| \`${LIB_NAME_UPPER}_DEFAULT_PIN\` | 13 | Default pin number |
| \`${LIB_NAME_UPPER}_DEFAULT_TIMEOUT\` | 1000 | Default timeout in ms |

## Error Codes

| Code | Description |
|------|-------------|
| 0 | No error |
| 1 | Initialization failed |
| 2 | Timeout error |
| 3 | Invalid parameter |

## Usage Examples

### Basic Usage

\`\`\`cpp
#include <$LIB_NAME.h>

$LIB_NAME device;

void setup() {
    if (!device.begin()) {
        // Handle error
    }
}

void loop() {
    device.process();
}
\`\`\`

### Advanced Configuration

\`\`\`cpp
$LIB_NAME device;

void setup() {
    device.begin(10);        // Custom pin
    device.setConfig(0x42);  // Custom config
}
\`\`\`
EOF

# Create GitHub Actions workflow
echo "Creating GitHub Actions workflow..."
cat > .github/workflows/compile.yml << EOF
name: Compile Examples

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        arduino-platform:
          - arduino:avr
          - esp32:esp32
          - esp8266:esp8266
        include:
          - arduino-platform: arduino:avr
            fqbn: arduino:avr:uno
          - arduino-platform: esp32:esp32
            fqbn: esp32:esp32:esp32
          - arduino-platform: esp8266:esp8266
            fqbn: esp8266:esp8266:generic

    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Arduino CLI
      uses: arduino/setup-arduino-cli@v1
      
    - name: Install platform
      run: |
        arduino-cli core update-index
        arduino-cli core install \${{ matrix.arduino-platform }}
        
    - name: Install library dependencies
      run: |
        # Add any library dependencies here
        # arduino-cli lib install "Dependency Name"
        echo "No dependencies to install"
        
    - name: Compile examples
      run: |
        for example in examples/*/; do
          echo "Compiling \$example"
          arduino-cli compile --fqbn \${{ matrix.fqbn }} "\$example" --warnings all
        done
EOF

# Create a quick test script
echo "Creating test script..."
cat > test_compile.sh << EOF
#!/bin/bash
# Quick compile test for all examples

BOARD="arduino:avr:uno"  # Change to your board

echo "Testing compilation of all examples..."
for example in examples/*/; do
    echo "Compiling \$example"
    arduino-cli compile --fqbn \$BOARD "\$example" || exit 1
done
echo "All examples compiled successfully!"
EOF
chmod +x test_compile.sh

# Final summary
echo ""
echo "✅ Library structure created successfully!"
echo ""
echo "📁 Created directory: $LIB_NAME/"
echo ""
echo "Next steps:"
echo "1. Review and customize the generated files"
echo "2. Implement your library functionality in src/"
echo "3. Update the examples with real code"
echo "4. Test compilation: ./test_compile.sh"
echo "5. Initialize git: git init && git add ."
echo "6. Create GitHub repository"
echo "7. Push to GitHub"
echo "8. Submit to Arduino Library Manager"
echo ""
echo "📚 Documentation guide: docs/LIBRARY_DOCUMENTATION_TEMPLATE.md"
