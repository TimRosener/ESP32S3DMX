# Contributing to ESP32S3DMX

First off, thank you for considering contributing to ESP32S3DMX! It's people like you that make this library better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (code snippets, DMX configurations)
- **Describe the behavior you observed**
- **Explain what behavior you expected**
- **Include your environment details**:
  - ESP32S3DMX version
  - Arduino Core version
  - Board type
  - DMX hardware setup

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List any alternatives you've considered**

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Add or update tests as needed
5. Update documentation
6. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
7. Push to the branch (`git push origin feature/AmazingFeature`)
8. Open a Pull Request

## Development Process

### Setting Up Your Development Environment

```bash
# Clone your fork
git clone https://github.com/yourusername/ESP32S3DMX.git
cd ESP32S3DMX

# Add upstream remote
git remote add upstream https://github.com/originalauthor/ESP32S3DMX.git

# Create a feature branch
git checkout -b feature/your-feature-name
```

### Code Style Guidelines

- **Indentation**: 4 spaces (no tabs)
- **Line Length**: 100 characters maximum
- **Braces**: Opening brace on same line
- **Naming**:
  - Classes: `PascalCase`
  - Methods/Functions: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
  - Private members: `camelCase` (no prefix)

Example:
```cpp
class ESP32S3DMX {
public:
    void begin(uint8_t uart_num = 2);
    uint8_t read(uint16_t channel);
    
private:
    static const uint16_t DMX_CHANNELS = 512;
    uint8_t dmxData[DMX_CHANNELS + 1];
};
```

### Testing Your Changes

1. **Test with real hardware** - Use actual DMX equipment when possible
2. **Test edge cases**:
   - No signal conditions
   - Signal loss and recovery
   - Partial universes
   - Maximum packet rates
3. **Run all examples** to ensure compatibility
4. **Test on multiple ESP32 variants** if possible

### Documentation

- Update README.md if you change the API
- Add inline comments for complex logic
- Update examples if adding new features
- Include code examples in your documentation

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Test additions or modifications
- `chore:` Maintenance tasks

Examples:
```
feat: add support for custom start codes
fix: correct channel offset for ESP32-S2
docs: update wiring diagram for clarity
```

## Release Process

1. Update version in `library.properties`
2. Update `CHANGELOG.md`
3. Create release commit: `git commit -m "chore: release v1.x.x"`
4. Tag the release: `git tag -a v1.x.x -m "Release version 1.x.x"`
5. Push with tags: `git push origin main --tags`

## Questions?

Feel free to open an issue with the `question` label or reach out to the maintainers.

Thank you for contributing! 🎉
