# Changelog

All notable changes to AETHER will be documented in this file.

## [3.6.0] - 2024-07-24

### ✨ New Features
- **Smart Input Validation**
  - LHOST validation (IP addresses, hostnames, localhost)
  - LPORT validation (port range 1-65535)
  - Filename validation and error handling

- **Payload Management**
  - New "View Payloads" menu option
  - Browse generated payloads with file sizes and modification dates
  - Quick file info display (type, size, modification time)

- **Favorites System**
  - Save favorite payload configurations
  - Quick access to custom setups
  - One-command retrieval

- **Enhanced Logging**
  - Auto-rotating logs (keeps last 1000 lines)
  - Detailed payload generation history
  - Clear logs functionality in Settings
  - Timestamps for all events

- **Improved User Interface**
  - Better color scheme and visual hierarchy
  - Progress indicators
  - Enhanced menu navigation
  - Clear status messages (✓, ✗, !, *)
  - More detailed error messages

- **New Payload Support**
  - Node.js reverse shell preset
  - Ruby payload support
  - PowerShell encoded payloads

- **Terminal Compatibility**
  - Support for Konsole (KDE)
  - Better fallback handling
  - Multiple terminal emulator options

### 🔄 Improvements
- More robust error handling throughout
- Better input validation with helpful feedback
- Cleaner configuration management
- Improved cache refresh logic (2-hour expiry)
- Better command preview formatting
- Enhanced confirmation dialogs

### 🐛 Bug Fixes
- Fixed file descriptor issues with input redirection
- Improved error handling for invalid selections
- Better handling of cancelled operations
- Fixed cache update timing issues

### 📚 Documentation
- Complete README overhaul
- Added detailed examples
- Added troubleshooting section
- Added configuration guide
- Added roadmap

### ⚙️ Technical Changes
- Refactored validation functions
- Improved shell safety (set -u, IFS handling)
- Better error propagation
- More efficient cache management

---

## [3.5.0] - 2024-07-23

### ✨ Features
- Interactive menu-driven interface
- Custom payload generation
- Quick presets for common payloads
- Auto-listener functionality
- Persistent configuration
- Payload caching with fzf integration
- Color-coded output
- Logging system

### 🎯 Capabilities
- Cross-platform payload support (Windows, Linux, Android, macOS, iOS, PHP, Python)
- Multi-architecture support (x86, x64, ARM, ARM64, MIPS)
- Multiple encoder support
- Adjustable encoding iterations
- Custom format selection
- Advanced msfconsole integration

### 📦 Installation
- One-line installation script
- Global command availability
- Automatic configuration setup
- Directory creation

---

## Notes

### Future Versions (Planned)

**v3.7.0**
- Command-line argument support
- Configuration presets export/import
- Batch payload generation
- WebUI dashboard

**v4.0.0**
- GUI interface
- Docker support
- Cloud integration
- Multi-user support
- Automated deployment options

---

## Breaking Changes

None in v3.6.0 - fully backward compatible with v3.5.0

---

## Migration Guide

### From v3.5.0 to v3.6.0

No migration needed! Your existing configuration files will continue to work:

```bash
# Simply update the script
cd AETHER
git pull origin main
bash install.sh

# Your config is safe
cat ~/.aether/config  # Still accessible
```

New features will be available immediately without any changes required.

---

## Installation

### Fresh Installation
```bash
git clone https://github.com/AhmedEmad-AEM/AETHER.git && cd AETHER && bash install.sh
```

### Update Existing Installation
```bash
cd AETHER
git pull origin main
bash install.sh  # Re-run to update /usr/local/bin
```

---

## Known Issues

### None Currently

Please report issues on GitHub: [Create Issue](https://github.com/AhmedEmad-AEM/AETHER/issues/new)

---

## Contributors

- **Ahmed Emad** - Lead Developer
- **Mohamed Nagy** - Co-Developer
- **Abdallah Negeada** - Co-Developer
- **Abdallah Salman** - Co-Developer

---

## License

MIT License - See LICENSE file for details

---

**Last Updated:** 2024-07-24

For more information, visit: https://github.com/AhmedEmad-AEM/AETHER
