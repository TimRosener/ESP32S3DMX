/*
  ChannelViewer.ino - Interactive DMX channel viewer
  
  This example provides an interactive way to view any range of DMX channels.
  Use the Serial Monitor to change which channels are displayed.
  
  Commands (type in Serial Monitor):
  - "1,16"   - Show channels 1-16
  - "45,8"   - Show channels 45-52
  - "100,32" - Show channels 100-131
  - Enter    - Refresh current view
*/

#include <ESP32S3DMX.h>

ESP32S3DMX dmx;

// Display settings
uint16_t startChannel = 1;
uint16_t channelCount = 16;

void setup() {
    Serial.begin(115200);
    delay(2000);
    
    Serial.println("\nESP32S3DMX Channel Viewer");
    Serial.println("=========================");
    Serial.println("Commands: START,COUNT (e.g., '45,8' shows ch 45-52)");
    Serial.println("Press Enter to refresh current view\n");
    
    dmx.begin();
    
    Serial.print("Showing channels ");
    Serial.print(startChannel);
    Serial.print("-");
    Serial.println(startChannel + channelCount - 1);
    Serial.println("\nWaiting for DMX signal...\n");
}

void parseCommand(String cmd) {
    cmd.trim();
    
    if (cmd.length() == 0) {
        // Just refresh
        return;
    }
    
    int commaPos = cmd.indexOf(',');
    if (commaPos > 0) {
        int newStart = cmd.substring(0, commaPos).toInt();
        int newCount = cmd.substring(commaPos + 1).toInt();
        
        // Validate
        if (newStart >= 1 && newStart <= 512 && 
            newCount >= 1 && newCount <= 512 &&
            (newStart + newCount - 1) <= 512) {
            
            startChannel = newStart;
            channelCount = newCount;
            
            Serial.print("\nNow showing channels ");
            Serial.print(startChannel);
            Serial.print("-");
            Serial.println(startChannel + channelCount - 1);
        } else {
            Serial.println("\nInvalid range! Use START,COUNT (1-512)");
        }
    }
}

void displayChannels() {
    Serial.print("Ch ");
    Serial.print(startChannel);
    Serial.print("-");
    Serial.print(startChannel + channelCount - 1);
    Serial.print(": ");
    
    // Display values with formatting
    for (uint16_t i = 0; i < channelCount; i++) {
        uint16_t ch = startChannel + i;
        uint8_t value = dmx.read(ch);
        
        if (value < 10) Serial.print("  ");
        else if (value < 100) Serial.print(" ");
        Serial.print(value);
        
        // Add separators for readability
        if ((i + 1) % 8 == 0 && i < channelCount - 1) {
            Serial.print(" |");
        }
        Serial.print(" ");
    }
    
    Serial.print(" [");
    Serial.print(dmx.getPacketRate(), 0);
    Serial.println(" Hz]");
}

void loop() {
    // Check for commands
    if (Serial.available()) {
        String cmd = Serial.readStringUntil('\n');
        parseCommand(cmd);
    }
    
    // Display channels
    if (dmx.isConnected()) {
        displayChannels();
    } else {
        Serial.println("No DMX signal");
    }
    
    delay(250);  // Update 4 times per second
}
