#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
BLUE='\e[1;34m'
CYAN="\e[0;36m"
YELLOW="\e[0;33m"
PURPLE="\e[1;35m"
NC='\e[0m'

# Check if the script is executed with sudo
if [ $(id -u) -ne 0 ]; then
    echo "${RED}This script must be run as root. Please run with sudo.${NC}"
    exit 1
fi

# Check if switchtowhonix.sh is present in /usr/local/bin
check_switchtowhonix() {
    if [ -f "/usr/local/bin/switchtowhonix.sh" ]; then
        return 0 # File exists
    else
        return 1 # File does not exist
    fi
}

# Function to add switchtowhonix.sh to /usr/local/bin
add_switchtowhonix() {
    echo "The script 'switchtowhonix.sh' is not present in /usr/local/bin."
    echo "Do you want to add it to /usr/local/bin? (Y/N)"

    read -r choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        sudo cp switchtowhonix.sh /usr/local/bin/switchtowhonix
        sudo chmod +x /usr/local/bin/switchtowhonix
        echo -e "${GREEN}[+]${NC} 'switchtowhonix' added to /usr/local/bin"
    else
        echo "${CYAN}[-]${NC}Skipping the addition of 'switchtowhonix.sh'"
    fi
    sleep 2
}

# Function to display the menu
display_menu() {
    clear
    echo -e ""
    cat << "EOF"
                .__  __         .__     __                .__                  .__        
  ________  _  _|__|/  |_  ____ |  |___/  |_  ______  _  _|  |__   ____   ____ |__|__  ___
 /  ___/\ \/ \/ /  \   __\/ ___\|  |  \   __\/  _ \ \/ \/ /  |  \ /  _ \ /    \|  \  \/  /
 \___ \  \     /|  ||  | \  \___|   Y  \  | (  <_> )     /|   Y  (  <_> )   |  \  |>    < 
/____  >  \/\_/ |__||__|  \___  >___|  /__|  \____/ \/\_/ |___|  /\____/|___|  /__/__/\_ \
     \/                       \/     \/                        \/            \/         \/
                                                                    By YoruYagami
EOF
    echo -e ""
    echo -e "\n Select an option from menu:"
    echo ""
    echo -e "\nKey      Menu Option:"
    echo -e "---      -------------------------"
    echo ""
    echo -e " 1    -  ${GREEN}Add${NC} Tor Whonix configuration"
    echo -e " 2    -  ${RED}Delete${NC} Tor Whonix configuration"
    echo -e " 3    -  ${BLUE}View${NC} Tor Whonix status"
    echo ""
    echo -e " 4    -  ${CYAN}Check${NC} if Tor service is up and running and start if not"
    echo -e " 5    -  ${PURPLE}Install${NC} Tor and Tor Browser"
}

# Function to check if Tor Whonix configuration exists
check_configuration() {
    if grep -q "#Tor Whonix" /etc/network/interfaces; then
        return 0 # Configuration exists
    else
        return 1 # Configuration does not exist
    fi
}

# Function to add the Tor Whonix configuration
add_configuration() {
    if check_configuration; then
        echo -e "${RED}[-]${NC} Error: Tor Whonix configuration already exists"
        sleep 2
        return
    fi

    # Add the configuration to the interfaces file
    sudo tee -a /etc/network/interfaces > /dev/null <<EOT
#Tor Whonix
auto eth0
iface eth0 inet static
address 10.152.152.12
netmask 255.255.192.0
gateway 10.152.152.10
EOT

    echo -e "${GREEN}[+]${NC} Tor Whonix configuration added to interfaces file"
    sleep 2
}

# Function to delete the Tor Whonix configuration
delete_configuration() {
    if ! check_configuration; then
        echo -e "${RED}[-]${NC} Error: Tor Whonix configuration does not exist"
        sleep 2
        return
    fi

    # Delete the configuration from the interfaces file
    sudo sed -i '/#Tor Whonix/,+5d' /etc/network/interfaces

    echo -e "${GREEN}[+]${NC} Tor Whonix configuration deleted from interfaces file"
    sleep 2
}

# Function to view Tor Whonix status
view_status() {
    if check_configuration; then
        echo -e "\n${GREEN}[+] Tor Whonix configuration is enabled${NC}"
    else
        echo -e "\n${RED}[-] Tor Whonix configuration is disabled${NC}"
    fi

    echo -e "\n${YELLOW}/etc/network/interfaces:${NC}"
    echo ""
    echo "----------------------------------------"
    cat /etc/network/interfaces
    echo "----------------------------------------"
    sleep 4
}

# Function to check if Tor service is running and start if not
check_and_start_tor_service() {
    if systemctl is-active --quiet tor; then
        echo -e "${GREEN}[+]${NC} Tor service is running"

        echo "Do you want to disable the Tor service? (Y/N)"
        read -r choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            systemctl stop tor
            systemctl disable tor
            echo -e "${GREEN}[+]${NC} Tor service disabled"
        else
            echo "${CYAN}[-]${NC} Skipping the disabling of Tor service"
        fi
    else
        echo -e "${RED}[-]${NC} Tor service is not running"

        if ! command -v tor &> /dev/null; then
            echo "The Tor service is not installed. Do you want to install it? (Y/N)"
            read -r choice
            if [[ $choice =~ ^[Yy]$ ]]; then
                # Check if system update is required
                echo "Do you want to update the system before installing Tor? (Y/N)"
                read -r update_choice
                if [[ $update_choice =~ ^[Yy]$ ]]; then
                    apt-get update
                    apt-get upgrade -y
                fi

                # Install Tor
                apt-get install -y tor torbrowser-launcher
                systemctl start tor
                echo -e "${GREEN}[+]${NC} Tor service installed and started"
            else
                echo "${CYAN}[-]${NC} Skipping the installation of Tor service"
            fi
        else
            echo "The Tor service is already installed. Do you want to start it? (Y/N)"
            read -r choice
            if [[ $choice =~ ^[Yy]$ ]]; then
                systemctl start tor
                echo -e "${GREEN}[+]${NC} Tor service started"
            else
                echo "${CYAN}[-]${NC} Skipping the start of Tor service"
            fi
        fi
    fi

    sleep 2
}

# Function to install Tor and Tor Browser
install_tor_and_tor_browser() {
    if ! command -v tor &> /dev/null || ! command -v torbrowser-launcher &> /dev/null; then
        echo -e "${BLUE}[*]${NC} Installing Tor and Tor Browser..."
        apt-get update
        apt-get install -y tor torbrowser-launcher
        echo -e "${GREEN}[+]${NC} Tor and Tor Browser installed successfully"
    else
        echo -e "${YELLOW}[!]${NC} Tor and Tor Browser are already installed"
    fi

    sleep 2
}

# Main script
check_switchtowhonix
while true; do
    display_menu

    # Read user input
    echo ""
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            add_configuration
            ;;
        2)
            delete_configuration
            ;;
        3)
            view_status
            ;;
        4)
            check_and_start_tor_service
            ;;
        5)
            install_tor_and_tor_browser
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done
