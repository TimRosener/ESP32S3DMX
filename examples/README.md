# ESP32S3DMX Examples

This directory contains example sketches demonstrating how to use the ESP32S3DMX library.

## BasicReceive
**File:** `BasicReceive.ino`

The simplest example showing how to:
- Initialize the DMX receiver
- Check connection status
- Read and display channel values
- Monitor packet statistics

Perfect for testing your hardware setup and getting started with the library.

## ChannelMonitor
**File:** `ChannelMonitor.ino`

Demonstrates how to:
- Monitor specific channels for changes
- Detect value thresholds
- React to different DMX values
- Implement mode switching based on DMX input
- Handle signal loss gracefully

Use this as a template for building DMX-controlled devices like LED fixtures, motors, or effects.

## ChannelViewer
**File:** `ChannelViewer.ino`

An interactive tool that:
- Displays any range of DMX channels
- Accepts Serial Monitor commands to change the view
- Shows channel values in a formatted display
- Updates in real-time

Useful for:
- Debugging DMX problems
- Monitoring specific channel ranges
- Testing DMX console output
- Learning channel assignments

## Hardware Setup for All Examples

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

**Note:** Connect DE and RE pins together for receive-only operation.

## Customizing Pin Assignments

All examples use default pins, but you can customize them:

```cpp
// Default initialization
dmx.begin();

// Custom pins
dmx.begin(2, 16, 17, 4);  // UART2, RX=GPIO16, TX=GPIO17, Enable=GPIO4
```

## Troubleshooting

If examples don't work:
1. Check wiring connections
2. Verify RS485 module power requirements
3. Try swapping A/B connections
4. Ensure DMX source is transmitting
5. Open Serial Monitor at 115200 baud
