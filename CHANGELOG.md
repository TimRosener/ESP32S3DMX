# Changelog

All notable changes to ESP32S3DMX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- Initial release
- Full DMX512 receiver implementation
- Support for ESP32, ESP32-S2, and ESP32-S3
- Arduino Core 3.0+ compatibility
- Automatic UART break detection
- Channel reading methods (single and multiple)
- Connection status monitoring
- Packet statistics and rate calculation
- Three comprehensive examples
- Full API documentation

### Technical Details
- Handles ESP32-S3 UART 1-byte offset automatically
- Thread-safe buffer management
- Zero-copy architecture for efficiency
- Tested with 192 and 512 channel DMX sources

### Known Limitations
- Receive only (no transmit support)
- No RDM support
- Single universe only

[1.0.0]: https://github.com/yourusername/ESP32S3DMX/releases/tag/v1.0.0
