/*
  ChannelMonitor.ino - Monitor specific DMX channels
  
  This example shows how to monitor specific DMX channels for changes
  and react to different values or thresholds.
  
  Use this as a template for creating DMX-controlled devices that
  respond to specific channels.
*/

#include <ESP32S3DMX.h>

ESP32S3DMX dmx;

// Define which channels to monitor
const uint16_t DIMMER_CHANNEL = 1;      // Master dimmer
const uint16_t RED_CHANNEL = 2;         // Red LED control
const uint16_t GREEN_CHANNEL = 3;       // Green LED control  
const uint16_t BLUE_CHANNEL = 4;        // Blue LED control
const uint16_t MODE_CHANNEL = 10;       // Mode selection

// Store previous values to detect changes
uint8_t lastDimmer = 0;
uint8_t lastRed = 0;
uint8_t lastGreen = 0;
uint8_t lastBlue = 0;
uint8_t lastMode = 0;

void setup() {
    Serial.begin(115200);
    delay(2000);
    
    Serial.println("\nESP32S3DMX Channel Monitor Example");
    Serial.println("==================================");
    Serial.println("Monitoring channels:");
    Serial.println("  Ch1: Master Dimmer");
    Serial.println("  Ch2-4: RGB Values");
    Serial.println("  Ch10: Mode Selection\n");
    
    dmx.begin();
    Serial.println("DMX receiver started\n");
}

void loop() {
    if (dmx.isConnected()) {
        // Read current values
        uint8_t dimmer = dmx.read(DIMMER_CHANNEL);
        uint8_t red = dmx.read(RED_CHANNEL);
        uint8_t green = dmx.read(GREEN_CHANNEL);
        uint8_t blue = dmx.read(BLUE_CHANNEL);
        uint8_t mode = dmx.read(MODE_CHANNEL);
        
        // Detect and report dimmer changes
        if (dimmer != lastDimmer) {
            Serial.print("Dimmer changed: ");
            Serial.print(dimmer);
            Serial.print(" (");
            Serial.print((dimmer * 100) / 255);
            Serial.println("%)");
            lastDimmer = dimmer;
            
            // Add your dimmer control code here
            // analogWrite(LED_PIN, dimmer);
        }
        
        // Detect RGB changes
        if (red != lastRed || green != lastGreen || blue != lastBlue) {
            Serial.print("RGB changed: (");
            Serial.print(red);
            Serial.print(", ");
            Serial.print(green);
            Serial.print(", ");
            Serial.print(blue);
            Serial.println(")");
            
            lastRed = red;
            lastGreen = green;
            lastBlue = blue;
            
            // Add your RGB LED control code here
            // setRGBLed(red, green, blue);
        }
        
        // Detect mode changes
        if (mode != lastMode) {
            Serial.print("Mode changed: ");
            Serial.print(mode);
            
            // Interpret mode values
            if (mode < 10) {
                Serial.println(" - Off");
            } else if (mode < 50) {
                Serial.println(" - Static");
            } else if (mode < 100) {
                Serial.println(" - Fade");
            } else if (mode < 150) {
                Serial.println(" - Strobe");
            } else if (mode < 200) {
                Serial.println(" - Rainbow");
            } else {
                Serial.println(" - Chase");
            }
            
            lastMode = mode;
            
            // Add your mode handling code here
            // setMode(mode);
        }
        
        // Example: Trigger action when dimmer crosses threshold
        if (dimmer > 200 && lastDimmer <= 200) {
            Serial.println(">>> High brightness threshold reached!");
        }
        
    } else {
        // Handle DMX signal loss
        if (lastDimmer != 0) {
            Serial.println("\n!!! DMX signal lost !!!");
            // Reset to safe state
            lastDimmer = 0;
            lastRed = 0;
            lastGreen = 0;
            lastBlue = 0;
            lastMode = 0;
            
            // Add your failsafe code here
            // turnOffAllOutputs();
        }
    }
    
    delay(50);  // Check 20 times per second
}
