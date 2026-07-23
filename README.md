# AETHER
# ⚡ AETHER - Payload Genesis v3.5

**Aether** is an advanced, interactive front-end for `msfvenom` built for Kali Linux. It transforms complex payload generation into a simple, menu-driven experience with a beautiful terminal interface.

---

## ✨ Features

- 🖥️ **Cross-Platform Payloads** – Generate payloads for Windows, Linux, Android, macOS (OSX), iOS, PHP, Python, and more.
- 🏗️ **Multi-Architecture Support** – x86, x64, ARM, ARM64, MIPS, and custom architectures.
- 🔐 **Advanced Encoders** – Built-in support for `x86/shikata_ga_nai`, `x64/xor`, `x86/xor_dynamic`, `cmd/powershell_base64`, and custom encoders with adjustable iterations.
- ⚡ **Quick Presets** – Instantly generate the most common Meterpreter and Shell payloads with one click.
- 🎧 **Auto-Listener** – Automatically generates an `msfconsole` resource script and launches a listener in a new terminal window.
- 💾 **Persistent Configuration** – Saves your default LHOST, LPORT, encoder, format, and architecture in `~/.aether/config`.
- 🔍 **Smart Payload Cache** – Caches all payloads locally and integrates with `fzf` for blazing-fast fuzzy searching.

---

## 📋 Requirements

- **Kali Linux** (or any Debian-based distribution).
- **Metasploit Framework** installed (`msfvenom` and `msfconsole` must be available in your PATH).

  To install Metasploit on Kali (if not already present):
  ```bash
  sudo apt update && sudo apt install metasploit-framework -y
  ```

---

## 🔧 One-Line Installation

The easiest way to install Aether globally:

```bash
git clone https://github.com/AhmedEmad-AEM/AETHER.git && cd AETHER && bash install.sh
```

After running this, you can simply type `aether` in your terminal from **anywhere** to launch the tool.

---

## 🚀 Quick Start Guide

1. Open your terminal.
2. Type `aether` and press **Enter**.
3. Use the interactive menu:
   - **Option 1:** Generate a custom payload (choose platform, architecture, payload type, etc.).
   - **Option 2:** Quick Presets for the most popular payloads.
   - **Option 3:** Start a listener to catch incoming connections.
   - **Option 4:** Adjust default settings (LHOST, LPORT, etc.).
   - **Option 5:** Exit.

All generated payloads are saved by default in: `~/aether_payloads/`

---

## 👨‍💻 Development Team

This tool was crafted with passion by:

- **Ahmed Emad**
- **Mohamed Nagy**
- **Abdallah Negeada**
- **Abdallah Salman**

---

## ⚠️ Disclaimer

This tool is intended for **educational purposes**, authorized penetration testing, and security research only. The authors are not responsible for any misuse or illegal activities performed with this software. Use responsibly and ethically.
