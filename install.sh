#!/bin/bash

# ─── Colors ───
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

print_header() {
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║   AETHER - Installation v3.6.0         ║${NC}"
    echo -e "${BOLD}${GREEN}║   Payload Genesis for Kali Linux       ║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_step() {
    echo
    echo -e "${BLUE}${BOLD}Step $1:${NC} $2"
    echo -e "${BLUE}─────────────────────────────────────────${NC}"
}

main() {
    print_header
    
    print_step "1" "Verifying AETHER files"
    
    if [ ! -f "aether" ]; then
        print_error "File 'aether' not found in current directory"
        print_info "Please run this installer from the AETHER repository root"
        echo "  cd AETHER && bash install.sh"
        exit 1
    fi
    print_success "Found aether script"
    
    print_step "2" "Checking dependencies"
    
    local missing_deps=()
    
    if ! command -v msfvenom &>/dev/null; then
        missing_deps+=("msfvenom")
    else
        print_success "Found msfvenom"
    fi
    
    if ! command -v msfconsole &>/dev/null; then
        missing_deps+=("msfconsole")
    else
        print_success "Found msfconsole"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing: ${missing_deps[*]}"
        echo
        print_info "Install Metasploit Framework:"
        echo "  ${CYAN}sudo apt update && sudo apt install metasploit-framework -y${NC}"
        echo
        read -rp "Continue anyway? (y/n): " continue_anyway
        if [ "$continue_anyway" != "y" ]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    print_step "3" "Setting permissions"
    
    chmod +x aether
    if [ $? -eq 0 ]; then
        print_success "Made aether executable"
    else
        print_error "Failed to set permissions"
        exit 1
    fi
    
    print_step "4" "Checking for existing installation"
    
    if [ -f "/usr/local/bin/aether" ]; then
        print_info "AETHER is already installed at /usr/local/bin/aether"
        read -rp "Overwrite existing installation? (y/n): " overwrite
        if [ "$overwrite" != "y" ]; then
            print_success "Installation cancelled - keeping existing version"
            exit 0
        fi
    fi
    
    print_step "5" "Installing AETHER globally"
    
    echo "  Requires sudo privileges..."
    if sudo cp aether /usr/local/bin/aether 2>/dev/null; then
        sudo chmod +x /usr/local/bin/aether
        print_success "Installed to /usr/local/bin/aether"
    else
        print_error "Failed to copy file (permission denied)"
        echo
        print_info "Try running with sudo:"
        echo "  ${CYAN}sudo bash install.sh${NC}"
        exit 1
    fi
    
    print_step "6" "Creating convenience symlink"
    
    if sudo ln -sf /usr/local/bin/aether /usr/bin/aether 2>/dev/null; then
        print_success "Created symlink: /usr/bin/aether"
    else
        print_warning "Could not create symlink (non-critical)"
    fi
    
    print_step "7" "Creating user directories"
    
    mkdir -p ~/.aether 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "Created: ~/.aether"
    else
        print_error "Failed to create ~/.aether"
    fi
    
    mkdir -p ~/.aether/cache 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "Created: ~/.aether/cache"
    else
        print_error "Failed to create ~/.aether/cache"
    fi
    
    mkdir -p ~/aether_payloads 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "Created: ~/aether_payloads"
    else
        print_error "Failed to create ~/aether_payloads"
    fi
    
    print_step "8" "Verifying installation"
    
    if command -v aether &>/dev/null; then
        print_success "'aether' is available in PATH"
        local aether_path=$(command -v aether)
        print_info "Location: $aether_path"
    else
        print_error "'aether' not found in PATH"
        echo
        print_info "Try running: source ~/.bashrc"
        echo "Or restart your terminal"
    fi
    
    print_step "9" "Installation Complete!"
    
    echo
    echo -e "${GREEN}${BOLD}✓ AETHER has been successfully installed!${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}Quick Start:${NC}"
    echo "  ${GREEN}aether${NC}              Launch the application"
    echo "  ${GREEN}sudo aether${NC}         Run with elevated privileges"
    echo
    
    echo -e "${CYAN}${BOLD}Important Directories:${NC}"
    echo "  ${YELLOW}Configuration:${NC}  ~/.aether/config"
    echo "  ${YELLOW}Payloads:${NC}        ~/aether_payloads"
    echo "  ${YELLOW}Logs:${NC}            ~/.aether/aether.log"
    echo "  ${YELLOW}Cache:${NC}           ~/.aether/cache"
    echo
    
    echo -e "${CYAN}${BOLD}Optional Enhancements:${NC}"
    
    if command -v fzf &>/dev/null; then
        print_success "fzf found (fuzzy search enabled)"
    else
        print_info "Install fzf for fuzzy payload search:"
        echo "    ${CYAN}sudo apt install fzf${NC}"
    fi
    
    if command -v xterm &>/dev/null; then
        print_success "xterm found (listener window support)"
    elif command -v gnome-terminal &>/dev/null; then
        print_success "gnome-terminal found (listener window support)"
    elif command -v konsole &>/dev/null; then
        print_success "konsole found (listener window support)"
    else
        print_info "Install a terminal emulator for listener support:"
        echo "    ${CYAN}sudo apt install xterm${NC}"
    fi
    
    echo
    echo -e "${GREEN}${BOLD}Ready to use! Type 'aether' to launch.${NC}"
    echo
    
    read -rp "Launch AETHER now? (y/n): " launch
    if [ "$launch" = "y" ]; then
        aether
    fi
}

trap 'print_error "Installation interrupted"; exit 1' INT TERM

main "$@"
exit 0
