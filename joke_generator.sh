#!/bin/bash

################################################################################
#                                                                              #
#                    🎭 RANDOM JOKE GENERATOR v1.0                           #
#                                                                              #
#  Description: Fetch and display random jokes from an external API          #
#  Author: AETHER Generator                                                   #
#  License: MIT                                                               #
#                                                                              #
################################################################################

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Symbols
SUCCESS="✓"
ERROR="✗"
INFO="ℹ"
JOKE="😂"

################################################################################
# FUNCTION: display_banner
# PURPOSE: Display the script banner
################################################################################
display_banner() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}     ${WHITE}🎭 RANDOM JOKE GENERATOR ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     Fetch hilarious jokes from the internet!           ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCTION: check_dependencies
# PURPOSE: Verify required tools are installed
################################################################################
check_dependencies() {
    local missing_deps=0
    
    echo -e "${CYAN}${INFO} Checking dependencies...${NC}"
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}${ERROR} curl is not installed${NC}"
        missing_deps=1
    else
        echo -e "${GREEN}${SUCCESS} curl found${NC}"
    fi
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}${ERROR} jq is not installed (required for JSON parsing)${NC}"
        missing_deps=1
    else
        echo -e "${GREEN}${SUCCESS} jq found${NC}"
    fi
    
    # Check for internet connectivity
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        echo -e "${YELLOW}${INFO} Internet connectivity may be limited${NC}"
    else
        echo -e "${GREEN}${SUCCESS} Internet connection active${NC}"
    fi
    
    echo ""
    
    if [ $missing_deps -eq 1 ]; then
        echo -e "${RED}${ERROR} Missing required dependencies!${NC}"
        echo -e "${YELLOW}Install them using:${NC}"
        echo -e "${CYAN}  # Ubuntu/Debian${NC}"
        echo -e "  sudo apt-get install curl jq"
        echo -e "${CYAN}  # macOS${NC}"
        echo -e "  brew install curl jq"
        return 1
    fi
    
    return 0
}

################################################################################
# FUNCTION: fetch_joke
# PURPOSE: Fetch a random joke from JokeAPI
# PARAMETERS: $1 = joke type (any, programming, knock-knock)
################################################################################
fetch_joke() {
    local joke_type="${1:-any}"
    local api_url="https://v2.jokeapi.dev/joke/${joke_type}?format=json"
    
    echo -e "${CYAN}${INFO} Fetching ${joke_type} joke...${NC}"
    
    # Fetch the joke with timeout
    local response=$(curl -s --max-time 10 "${api_url}")
    
    # Check if curl was successful
    if [ $? -ne 0 ]; then
        echo -e "${RED}${ERROR} Failed to fetch joke. Check your internet connection.${NC}"
        return 1
    fi
    
    # Parse the response
    local error=$(echo "$response" | jq -r '.error' 2>/dev/null)
    
    if [ "$error" = "true" ]; then
        echo -e "${RED}${ERROR} API Error: $(echo "$response" | jq -r '.message')${NC}"
        return 1
    fi
    
    # Display the joke
    display_joke "$response"
    
    return 0
}

################################################################################
# FUNCTION: display_joke
# PURPOSE: Display the fetched joke in a formatted manner
# PARAMETERS: $1 = JSON response from API
################################################################################
display_joke() {
    local response="$1"
    local joke_type=$(echo "$response" | jq -r '.type')
    
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${WHITE}${JOKE}  JOKE TIME!${MAGENTA}  ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$joke_type" = "single" ]; then
        # Single-part joke
        local joke=$(echo "$response" | jq -r '.joke')
        echo -e "${YELLOW}${joke}${NC}"
    elif [ "$joke_type" = "twopart" ]; then
        # Two-part joke
        local setup=$(echo "$response" | jq -r '.setup')
        local delivery=$(echo "$response" | jq -r '.delivery')
        echo -e "${YELLOW}${setup}${NC}"
        echo ""
        read -p "Press Enter for the punchline... "
        echo -e "${CYAN}${delivery}${NC}"
    fi
    
    echo ""
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# FUNCTION: show_menu
# PURPOSE: Display the main menu
################################################################################
show_menu() {
    echo -e "${CYAN}┌─ JOKE CATEGORIES ─┐${NC}"
    echo -e "${GREEN}1)${NC} Any Joke"
    echo -e "${GREEN}2)${NC} Programming Joke"
    echo -e "${GREEN}3)${NC} Knock-Knock Joke"
    echo -e "${GREEN}4)${NC} Random (All Types)"
    echo -e "${GREEN}5)${NC} Help"
    echo -e "${GREEN}0)${NC} Exit"
    echo -e "${CYAN}└───────────────────┘${NC}"
    echo ""
}

################################################################################
# FUNCTION: get_multiple_jokes
# PURPOSE: Fetch and display multiple jokes
# PARAMETERS: $1 = number of jokes, $2 = joke type
################################################################################
get_multiple_jokes() {
    local count="${1:-1}"
    local joke_type="${2:-any}"
    
    for ((i=1; i<=count; i++)); do
        echo -e "${BLUE}[${i}/${count}]${NC}"
        fetch_joke "$joke_type"
        
        if [ $i -lt $count ]; then
            read -p "Press Enter for the next joke... "
        fi
    done
}

################################################################################
# FUNCTION: main
# PURPOSE: Main program logic
################################################################################
main() {
    display_banner
    
    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi
    
    # Main loop
    while true; do
        show_menu
        read -p "Enter your choice (0-5): " choice
        echo ""
        
        case $choice in
            1)
                fetch_joke "any"
                ;;
            2)
                fetch_joke "programming"
                ;;
            3)
                fetch_joke "knock-knock"
                ;;
            4)
                read -p "How many jokes do you want? (default: 1): " num_jokes
                num_jokes=${num_jokes:-1}
                get_multiple_jokes "$num_jokes" "any"
                ;;
            5)
                display_help
                ;;
            0)
                echo -e "${GREEN}Thanks for using Joke Generator! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                sleep 1
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            read -p "Press Enter to continue... "
            clear
            display_banner
        fi
    done
}

################################################################################
# FUNCTION: display_help
# PURPOSE: Display help information
################################################################################
display_help() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${WHITE}                         HELP MENU${CYAN}                         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}USAGE:${NC}"
    echo -e "  ${CYAN}./joke_generator.sh${NC}"
    echo ""
    echo -e "${WHITE}FEATURES:${NC}"
    echo -e "  • Fetch random jokes from JokeAPI"
    echo -e "  • Multiple joke categories (any, programming, knock-knock)"
    echo -e "  • Get multiple jokes in a row"
    echo -e "  • Beautiful colored output"
    echo -e "  • Interactive menu system"
    echo ""
    echo -e "${WHITE}REQUIREMENTS:${NC}"
    echo -e "  • curl - for API requests"
    echo -e "  • jq - for JSON parsing"
    echo -e "  • Internet connection"
    echo ""
    echo -e "${WHITE}API:${NC}"
    echo -e "  This script uses JokeAPI (https://v2.jokeapi.dev/)"
    echo -e "  No authentication required!"
    echo ""
    echo -e "${WHITE}EXAMPLES:${NC}"
    echo -e "  # Run the script interactively"
    echo -e "  ${CYAN}./joke_generator.sh${NC}"
    echo ""
    read -p "Press Enter to return to menu... "
}

# Run the main function
main
