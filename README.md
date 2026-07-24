<!-- Animated Banner -->
<div align="center">
  
# ⚡ AETHER - Payload Genesis v3.6

## The Advanced Metasploit Frontend for Kali Linux

[![Version](https://img.shields.io/badge/Version-3.6.0-blue?style=for-the-badge&logo=github)](https://github.com/AhmedEmad-AEM/AETHER)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-5.0+-red?style=for-the-badge&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![Kali](https://img.shields.io/badge/Kali%20Linux-2024.x-blueviolet?style=for-the-badge)](https://www.kali.org)

<img width="800" alt="AETHER Banner" src="https://github.com/user-attachments/assets/5216c163-d935-40db-8c71-c948ad3d55fa" />

**🎯 Transform Complex Payload Generation Into Simple, Elegant Interactions**

[Installation](#-one-line-installation) • [Features](#-features) • [Quick Start](#-quick-start-guide) • [Usage](#-usage-guide) • [Examples](#-examples) • [Contributing](#-contributing)

</div>

---

## ✨ Features

### Core Capabilities
- 🖥️ **Cross-Platform Payloads** – Windows, Linux, Android, macOS, iOS, PHP, Python, Node.js, Ruby
- 🏗️ **Multi-Architecture Support** – x86, x64, ARM, ARM64, MIPS, and custom
- 🔐 **Advanced Encoders** – shikata_ga_nai, xor, powershell_base64, and custom encoders
- ⚡ **Quick Presets** – 10 pre-configured templates for common scenarios
- 🎧 **Auto-Listener** – Automatically launch msfconsole handlers

### New in v3.6.0 ✨
- ✅ **Smart Input Validation** – Real-time LHOST/LPORT validation
- 📁 **Payload Management** – View and organize all generated payloads
- ⭐ **Favorites System** – Save your favorite configurations
- 📊 **Enhanced Logging** – Auto-rotating logs with full history
- 🎨 **Improved UI** – Better colors, progress, and intuitive menus
- 🛡️ **Error Handling** – Comprehensive validation and helpful feedback
- 💾 **Config Management** – Persistent settings with clear logs
- 🔍 **Fuzzy Search** – Optional fzf integration for fast selection

---

## 📋 Requirements

### Minimum
- **Kali Linux** 2024.x or Debian-based distro
- **Metasploit Framework** (msfvenom, msfconsole)
- **Bash** 4.0+

### Optional Enhancements
- **fzf** – For fuzzy search (fallback to manual selection)
- **xterm/gnome-terminal/konsole** – For listener windows

---

## 🔧 Installation

### One-Line Installation ⚡ (Recommended)

```bash
git clone https://github.com/AhmedEmad-AEM/AETHER.git && cd AETHER && bash install.sh
```

Then launch from anywhere:
```bash
aether
```

### Install Metasploit (if needed)
```bash
sudo apt update && sudo apt install metasploit-framework -y
```

---

## 🚀 Quick Start Guide

### Launch AETHER
```bash
aether              # Regular user
sudo aether         # With elevated privileges
```

### Main Menu
```
1) Generate Payload      → Customize everything
2) Quick Presets         → Pre-configured templates
3) Saved Favorites       → Your custom configs
4) Start Listener        → Launch handler
5) Settings              → Configure defaults
6) View Payloads         → Browse generated files
0) Exit                  → Quit
```

---

## 📖 Usage Guide

### 1️⃣ Generate Custom Payload

```bash
aether → 1 → Select platform/arch/type/format/encoder → Confirm → Done
```

**Step-by-step:**
- Select target platform (Windows, Linux, etc.)
- Choose architecture (x86, x64, ARM, etc.)
- Pick payload type (meterpreter, shell, custom)
- Enter LHOST (listener IP - validated)
- Enter LPORT (listener port - validated 1-65535)
- Choose output format (exe, elf, python, ps1, etc.)
- Select encoder (none, shikata_ga_nai, xor, etc.)
- Preview command and confirm
- **Optional:** Save as favorite for quick reuse

---

### 2️⃣ Quick Presets

10 pre-configured payloads:

```
1) Windows x64 Meterpreter (exe)
2) Windows x64 Shell (exe)
3) Linux x64 Meterpreter (elf)
4) Linux x86 Shell (elf)
5) Android Meterpreter (raw)
6) macOS x64 Meterpreter (macho)
7) PHP Meterpreter (raw)
8) Python Reverse Shell (raw)
9) Node.js Reverse Shell (raw)
10) PowerShell Encoded (ps1)
```

**Usage:** `aether → 2 → Choose number → Enter LHOST/LPORT`

---

### 3️⃣ Saved Favorites

Access your most-used configurations instantly:

```bash
aether → 3 (View all saved favorites)
```

When generating, save a new favorite:
```
Save as favorite? (y/n): y
Favorite name: My Custom Config
✓ Added favorite
```

---

### 4️⃣ Start Listener

Launch reverse handler automatically:

```bash
aether → 4 → Select platform → Choose payload → Enter LHOST/LPORT
→ msfconsole launches in new terminal ✓
```

---

### 5️⃣ View Payloads

Browse all generated payloads:

```bash
aether → 6
  1) windows_reverse.exe        Size: 7.2M    Modified: 2024-07-24 15:30
  2) linux_shell.elf            Size: 894K    Modified: 2024-07-24 14:22
  3) android_payload.raw        Size: 512K    Modified: 2024-07-24 13:45
```

Select a number to view file details

---

## ⚙️ Configuration

All settings are stored in `~/.aether/`

```
~/.aether/config              # Settings file
~/.aether/aether.log          # Activity log
~/.aether/cache/              # Payload cache
~/.aether/favorites           # Saved configs
~/aether_payloads/            # Generated files
```

### Change Settings
```bash
aether → 5 (Settings)
  1) LHOST              7) Architecture
  2) LPORT              8) Output Directory
  3) Encoder            9) View Logs
  4) Iterations         10) Clear Logs
  5) Format
  6) Platform
```

---

## ✅ Input Validation

All inputs are validated for security:

### LHOST Validation
```
✓ IP Address:    192.168.1.100
✓ Hostname:      attacker.com
✓ Localhost:     localhost
✗ Invalid:       999.999.999.999
```

### LPORT Validation
```
✓ Valid:         1-65535
✗ Invalid:       0, 99999, "abc"
```

---

## 📊 Logging

Every action is logged for audit trails:

```bash
aether → 5 (Settings) → 9 (View Logs)

[2024-07-24 15:30:45] Generated: windows/x64/meterpreter/reverse_tcp
[2024-07-24 15:31:20] Started listener for linux/x64/shell_reverse_tcp
[2024-07-24 15:32:10] Added favorite: Windows Rev Shell
```

**Auto-rotation:** Keeps last 1000 lines to prevent bloat

---

## 🛠️ Troubleshooting

### "Missing msfvenom"
```bash
sudo apt update && sudo apt install metasploit-framework -y
sudo msfconsole  # Initialize database
```

### "No payloads found"
```bash
rm ~/.aether/cache/all_payloads.txt
aether  # Will rebuild cache
```

### Listener won't launch
```bash
sudo apt install xterm gnome-terminal konsole
# Test: msfconsole -q -r ~/.aether/listener.rc
```

### Permission denied
```bash
cd AETHER && sudo bash install.sh
```

---

## 💡 Examples

### Example 1: Windows Reverse Shell
```bash
aether → 1
Platform: Windows → x64 → meterpreter
LHOST: 192.168.1.100
LPORT: 4444
Format: exe
Encoder: shikata_ga_nai (5 iterations)
Filename: windows_payload
→ Output: ~/aether_payloads/windows_payload.exe
```

### Example 2: Linux Python Shell
```bash
aether → 1
Platform: Linux → x64 → shell
LHOST: attacker.com
LPORT: 5555
Format: python
Encoder: None
Filename: linux_shell
→ Output: ~/aether_payloads/linux_shell.python
```

### Example 3: Android APK
```bash
aether → 2 (Quick Presets) → 5 (Android)
LHOST: 10.0.0.5
LPORT: 6666
Filename: android_payload
→ Output: ~/aether_payloads/android_payload.raw
```

---

## 🔐 Security & Legal

### ⚠️ Important

**This tool is for authorized security testing only.**

- ✓ Use only on systems you own or have permission to test
- ✓ Obtain written authorization before testing
- ✗ Do NOT use for unauthorized access
- ✗ Do NOT distribute payloads without consent
- ✗ Unauthorized access is illegal

The authors are NOT responsible for misuse or illegal activities.

---

## 👨‍💻 Development Team

| Name | Role |
|:----:|:----:|
| Ahmed Emad | Lead Developer |
| Mohamed Nagy | Co-Developer |
| Abdallah Negeada | Co-Developer |
| Abdallah Salman | Co-Developer |

---

## 📈 Roadmap

**v3.6.0** ✅ (Current)
- Input validation
- Favorites system
- Payload viewer
- Enhanced logging

**v3.7.0** 🔄 (Planned)
- CLI arguments
- Batch generation
- WebUI dashboard

**v4.0.0** 🔮 (Future)
- GUI interface
- Docker support
- Cloud integration

---

## 🤝 Contributing

Found a bug? Want to improve AETHER?

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

**Issues:** [Report bug](https://github.com/AhmedEmad-AEM/AETHER/issues/new) | [Request feature](https://github.com/AhmedEmad-AEM/AETHER/issues/new)

---

## 📄 License

MIT License – See [LICENSE](LICENSE) file

---

<div align="center">

### ⭐ If you find AETHER useful, consider starring the repo!


**Stay Ethical. Stay Legal. Stay Secure.** 🔒

</div>
