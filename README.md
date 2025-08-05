# ESP32S3DMX Library

[![Arduino](https://img.shields.io/badge/Arduino-Library-blue)](https://www.arduino.cc/reference/en/libraries/)
[![License: LGPL v2.1](https://img.shields.io/badge/License-LGPL%20v2.1-blue.svg)](https://www.gnu.org/licenses/lgpl-2.1)
[![ESP32](https://img.shields.io/badge/ESP32-Core%203.0%2B-green)](https://github.com/espressif/arduino-esp32)

Professional DMX512 receiver library for ESP32 microcontrollers with Arduino Core 3.0+ support.

## Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Hardware Setup](#hardware-setup)
- [API Documentation](#api-documentation)
- [Examples](#examples)
- [Technical Details](#technical-details)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

| Feature | Status |
|---------|--------|
| Full 512 channel support | ✅ |
| Arduino Core 3.0+ compatible | ✅ |
| Automatic break detection | ✅ |
| Packet statistics | ✅ |
| Zero-copy channel reading | ✅ |
| Thread-safe operation | ✅ |
| Partial universe support | ✅ |
| Multiple UART support | ✅ |
| DMX transmission | ❌ |
| RDM support | ❌ |

### Performance Specifications
- **Packet Rate**: 44-50 Hz (standard DMX)
- **Latency**: < 1ms from packet reception to data availability
- **Memory Usage**: ~1.5KB RAM
- **CPU Usage**: < 1% at 50Hz packet rate

## Requirements

### Software
- Arduino IDE 1.8.13+ or PlatformIO
- ESP32 Arduino Core 3.0.0 or later
- No additional library dependencies

### Hardware
- ESP32, ESP32-S2, or ESP32-S3 development board
- RS485 transceiver module (MAX485, SN75176B, or equivalent)
- DMX512 signal source

### Tested Configurations
| Board | Core Version | Status |
|-------|--------------|--------|
| ESP32 DevKitC | 3.0.0 | ✅ Tested |
| ESP32-S2 | 3.0.0 | ✅ Tested |
| ESP32-S3 | 3.3.0 | ✅ Tested |

## Installation

### Method 1: Arduino Library Manager (Recommended)
1. Open Arduino IDE
2. Go to **Tools** → **Manage Libraries...**
3. Search for "ESP32S3DMX"
4. Click **Install**

### Method 2: Manual Installation
```bash
cd ~/Documents/Arduino/libraries
git clone https://github.com/yourusername/ESP32S3DMX.git
```

### Method 3: PlatformIO
Add to `platformio.ini`:
```ini
lib_deps = 
    https://github.com/yourusername/ESP32S3DMX.git
```

## Quick Start

```cpp
#include <ESP32S3DMX.h>

ESP32S3DMX dmx;

void setup() {
    Serial.begin(115200);
    dmx.begin();  // Initialize with default pins
}

void loop() {
    if (dmx.isConnected()) {
        uint8_t brightness = dmx.read(1);  // Read channel 1
        Serial.printf("Channel 1: %d\n", brightness);
    }
    delay(100);
}
```

## Hardware Setup

### Wiring Diagram

```
ESP32        RS485 Module     DMX Connector
------       ------------     -------------
GPIO 6  <--- RO               
GPIO 5  ---> DE/RE            
GPIO 4  ---> DI (NC)          
3V3/5V  ---> VCC              
GND     ---> GND -----------> Pin 1 (GND)
              A  -----------> Pin 3 (Data+)
              B  -----------> Pin 2 (Data-)
```

### Important Notes
- Connect DE and RE pins together for receive-only operation
- Some RS485 modules require 5V power (check specifications)
- DMX uses XLR 5-pin or 3-pin connectors
- 120Ω termination may be required for long cable runs

### Pin Configurations by Board

| Board | Default RX | Default TX | Default Enable | Recommended UART |
|-------|------------|------------|----------------|------------------|
| ESP32 | GPIO 16 | GPIO 17 | GPIO 4 | UART2 |
| ESP32-S2 | GPIO 6 | GPIO 4 | GPIO 5 | UART1 |
| ESP32-S3 | GPIO 6 | GPIO 4 | GPIO 5 | UART2 |

## API Documentation

### Class: ESP32S3DMX

#### Constructor
```cpp
ESP32S3DMX()
```
Creates a new DMX receiver instance. Only one instance should be created per UART.

#### Methods

##### begin()
```cpp
void begin(uint8_t uart_num = 2, int rx_pin = 6, int tx_pin = 4, int enable_pin = 5)
```
Initializes the DMX receiver.

**Parameters:**
- `uart_num`: UART peripheral to use (1 or 2, not 0 on ESP32-S3)
- `rx_pin`: GPIO pin connected to RS485 RO (receiver output)
- `tx_pin`: GPIO pin connected to RS485 DI (driver input) - unused for receive
- `enable_pin`: GPIO pin connected to RS485 DE/RE (direction control)

**Example:**
```cpp
dmx.begin();  // Use defaults
dmx.begin(2, 16, 17, 4);  // Custom pins
```

##### end()
```cpp
void end()
```
Stops the DMX receiver and releases resources.

##### read()
```cpp
uint8_t read(uint16_t channel)
```
Reads a single DMX channel value.

**Parameters:**
- `channel`: DMX channel number (1-512)

**Returns:** Channel value (0-255), or 0 if channel is invalid or no signal

**Example:**
```cpp
uint8_t dimmer = dmx.read(1);
uint8_t red = dmx.read(2);
```

##### readChannels()
```cpp
uint16_t readChannels(uint8_t* buffer, uint16_t start_channel, uint16_t count)
```
Reads multiple consecutive channels efficiently.

**Parameters:**
- `buffer`: Array to store channel values
- `start_channel`: First channel to read (1-512)
- `count`: Number of channels to read

**Returns:** Number of channels actually read

**Example:**
```cpp
uint8_t rgbw[4];
dmx.readChannels(rgbw, 10, 4);  // Read channels 10-13
```

##### isConnected()
```cpp
bool isConnected()
```
Checks if receiving valid DMX signal.

**Returns:** `true` if DMX received within last second, `false` otherwise

##### getPacketRate()
```cpp
float getPacketRate()
```
Gets the current packet reception rate.

**Returns:** Packets per second (0.0 if no signal)

##### Additional Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `getPacketCount()` | `uint32_t` | Total valid packets received |
| `getErrorCount()` | `uint32_t` | Total reception errors |
| `timeSinceLastPacket()` | `uint32_t` | Milliseconds since last packet |
| `getLastPacketSize()` | `uint16_t` | Size of last packet (bytes) |
| `getBuffer()` | `const uint8_t*` | Direct access to DMX buffer |

## Examples

### BasicReceive
Simple DMX channel display - perfect for getting started.
```cpp
// Displays first 8 channels continuously
```

### ChannelMonitor
Monitor specific channels and trigger actions on changes.
```cpp
// Detect changes, thresholds, and mode switches
```

### ChannelViewer
Interactive channel viewer with Serial Monitor commands.
```cpp
// View any range of channels interactively
```

## Technical Details

### DMX512 Protocol Implementation
- **Baud Rate**: 250,000 bps
- **Format**: 8 data bits, no parity, 2 stop bits (8N2)
- **Break**: Minimum 88μs (detected via UART error)
- **MAB**: Minimum 8μs (tolerates down to 2μs)
- **Start Code**: 0x00 (null start code only)

### ESP32-S3 UART Behavior
The ESP32-S3 UART hardware captures an extra byte at the beginning of the break signal. This library automatically compensates for this behavior, ensuring correct channel mapping.

### Memory Layout
```
dmxData[0]   = Start code (0x00)
dmxData[1]   = Channel 1
dmxData[2]   = Channel 2
...
dmxData[512] = Channel 512
```

### Thread Safety
- Channel data is copied atomically
- Safe to read from main loop while receiving
- No mutex required for reading operations

## Troubleshooting

### Common Issues and Solutions

| Problem | Possible Causes | Solutions |
|---------|----------------|-----------|
| No signal detected | Wiring issue | Check connections, verify power |
| | Wrong polarity | Swap A/B connections |
| | No DMX source | Verify console is outputting |
| Wrong channel values | Universe size | Check console universe settings |
| | Channel offset | Verify channel numbering |
| Intermittent signal | Termination | Add 120Ω terminator |
| | Cable quality | Use DMX-rated cable |
| Compilation error | Core version | Update to Core 3.0+ |

### Debug Checklist
1. ✓ RS485 module powered (LED indicator?)
2. ✓ DE/RE pins connected together and to GPIO
3. ✓ A/B polarity correct (try swapping)
4. ✓ DMX source actively transmitting
5. ✓ Using UART1 or UART2 (not UART0)

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### Development Setup
```bash
git clone https://github.com/yourusername/ESP32S3DMX.git
cd ESP32S3DMX
# Create feature branch
git checkout -b feature/your-feature
```

### Code Style
- Use 4 spaces for indentation
- Follow Arduino style guide
- Document all public methods
- Include examples for new features

## License

This library is licensed under the [GNU Lesser General Public License v2.1](LICENSE).

## Acknowledgments

- ESP32 Arduino Core team for Core 3.0
- DMX512 specification by ESTA
- RS485 transceiver manufacturers
- All contributors and testers

---

**Need Help?** Open an [issue](https://github.com/yourusername/ESP32S3DMX/issues) on GitHub.
