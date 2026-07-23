
# ⚡ AETHER - Payload Genesis v3.5.0

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
