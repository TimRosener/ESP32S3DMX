/*
  BasicReceive.ino - Basic DMX reception example
  
  This example demonstrates basic DMX512 reception using the ESP32S3DMX library.
  It continuously displays the values of the first 8 DMX channels.
  
  Hardware Setup:
  - ESP32/ESP32S2/ESP32S3 board
  - RS485 transceiver (MAX485 or similar)
  - Connect RS485 module to ESP32:
    - RO  → GPIO 6 (RX)
    - DI  → GPIO 4 (TX)
    - DE  → GPIO 5
    - RE  → GPIO 5
  - Connect RS485 to DMX:
    - A → DMX+ (pin 3)
    - B → DMX- (pin 2)
    - GND → DMX GND (pin 1)
*/

#include <ESP32S3DMX.h>

ESP32S3DMX dmx;

void setup() {
    Serial.begin(115200);
    delay(2000);  // Wait for Serial Monitor
    
    Serial.println("\nESP32S3DMX Basic Receive Example");
    Serial.println("================================\n");
    
    // Initialize DMX receiver on UART2 with default pins
    dmx.begin();
    
    // Or specify custom pins:
    // dmx.begin(2, 16, 17, 4);  // UART2, RX=16, TX=17, EN=4
    
    Serial.println("Waiting for DMX signal...\n");
}

void loop() {
    if (dmx.isConnected()) {
        // Display first 8 channels
        Serial.print("DMX: ");
        for (int i = 1; i <= 8; i++) {
            uint8_t value = dmx.read(i);
            if (value < 10) Serial.print("  ");
            else if (value < 100) Serial.print(" ");
            Serial.print(value);
            Serial.print(" ");
        }
        
        // Show packet rate and statistics
        Serial.print(" | ");
        Serial.print(dmx.getPacketRate(), 1);
        Serial.print(" Hz | Packets: ");
        Serial.print(dmx.getPacketCount());
        Serial.println();
        
    } else {
        Serial.print("No DMX signal");
        uint32_t lastPacket = dmx.timeSinceLastPacket();
        if (lastPacket != 0xFFFFFFFF) {
            Serial.print(" (last seen ");
            Serial.print(lastPacket / 1000.0, 1);
            Serial.print("s ago)");
        }
        Serial.println();
    }
    
    delay(100);  // Update 10 times per second
}
