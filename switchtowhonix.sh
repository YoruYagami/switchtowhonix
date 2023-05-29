#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
BLUE='\e[1;34m'
CYAN="\e[0;36m"
YELLOW="\e[0;33m"
NC='\e[0m'

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
    echo ""
    echo "Please select an option:"
    echo ""
    echo "1. Add Tor Whonix configuration"
    echo "2. Delete Tor Whonix configuration"
    echo "3. View Tor Whonix status"
    echo "4. Exit"
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
        echo -e "${GREEN}[+]${NC} Tor Whonix configuration is enabled"
    else
        echo -e "${RED}[-]${NC} Tor Whonix configuration is disabled"
    fi

    sleep 2
}

# Main script
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
            echo "Exiting..."
            sleep 1
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            sleep 2
            ;;
    esac
done
