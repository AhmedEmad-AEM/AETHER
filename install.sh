#!/bin/bash

# ─── Colors ───
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BOLD}${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   AETHER - Installer v3.5.0            ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════╝${NC}"
echo

# 1. Check if the main script exists
if [ ! -f "aether" ]; then
    echo -e "${RED}[!] Error: 'aether' file not found in current directory.${NC}"
    echo -e "${YELLOW}[*] Please make sure you are in the correct folder.${NC}"
    exit 1
fi

# 2. Make it executable
echo -e "${YELLOW}[*] Making 'aether' executable...${NC}"
chmod +x aether
echo -e "${GREEN}[+] Done.${NC}"

# 3. Check if already installed in /usr/local/bin
if [ -f "/usr/local/bin/aether" ]; then
    echo -e "${YELLOW}[*] Aether is already installed at /usr/local/bin/aether${NC}"
    read -rp "Overwrite? (y/n): " overwrite
    if [[ "$overwrite" != "y" ]]; then
        echo -e "${GREEN}[+] Installation cancelled.${NC}"
        exit 0
    fi
fi

# 4. Move to /usr/local/bin
echo -e "${YELLOW}[*] Moving 'aether' to /usr/local/bin/ (requires sudo)...${NC}"
if sudo mv aether /usr/local/bin/; then
    sudo chmod +x /usr/local/bin/aether
    echo -e "${GREEN}[+] Successfully installed to /usr/local/bin/aether${NC}"
else
    echo -e "${RED}[!] Failed to move file. Try: sudo bash install.sh${NC}"
    exit 1
fi

# 5. Create symlink in /usr/bin so sudo can find it
echo -e "${YELLOW}[*] Creating symlink in /usr/bin/aether...${NC}"
sudo ln -sf /usr/local/bin/aether /usr/bin/aether
if [ -L "/usr/bin/aether" ]; then
    echo -e "${GREEN}[+] Symlink created: /usr/bin/aether -> /usr/local/bin/aether${NC}"
else
    echo -e "${YELLOW}[!] Symlink creation may have failed. You may still use 'sudo /usr/local/bin/aether'${NC}"
fi

# 6. Create user directories
echo -e "${YELLOW}[*] Creating configuration directories...${NC}"
mkdir -p ~/.aether
mkdir -p ~/aether_payloads
echo -e "${GREEN}[+] Configuration: ~/.aether${NC}"
echo -e "${GREEN}[+] Payload output: ~/aether_payloads${NC}"

# 7. Verify sudo access
if sudo -n true 2>/dev/null; then
    if sudo command -v aether >/dev/null 2>&1; then
        echo -e "${GREEN}[+] 'sudo aether' will work as expected.${NC}"
    else
        echo -e "${YELLOW}[!] 'sudo aether' might still not work. Try: sudo /usr/bin/aether${NC}"
    fi
else
    echo -e "${YELLOW}[!] Note: If you need 'sudo aether', ensure /usr/bin is in sudo's secure_path.${NC}"
fi

# 8. Success message
echo
echo -e "${BOLD}${GREEN}✅ Installation Complete!${NC}"
echo -e "${BOLD}You can now run Aether from anywhere by typing:${NC}"
echo -e "   ${GREEN}aether${NC}"
echo -e "${BOLD}And with sudo:${NC}"
echo -e "   ${GREEN}sudo aether${NC}"
echo
echo -e "${YELLOW}Enjoy responsibly! 🚀${NC}"
