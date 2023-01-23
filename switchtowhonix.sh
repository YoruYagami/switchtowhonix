#!/bin/bash

# function to display help message
display_help() {
    echo "Usage: $0 [add|delete] [--help] [dns]"
    echo "add: adds the Tor Whonix configuration to the interfaces and resolv.conf files"
    echo "delete: deletes the Tor Whonix configuration from the interfaces and resolv.conf files and replaces nameserver 10.152.152.10 with 9.9.9.9 or provided dns"
    echo "dns: use this option to provide dns server to be used instead of 9.9.9.9"
    echo "--help: displays this help message"
}

# check if user provided enough arguments
if [ $# -lt 1 ]; then
    echo "Error: not enough arguments provided"
    display_help
    exit 1
fi

# check if user wants to display help message
if [ "$1" == "--help" ]; then
    display_help
    exit 0
fi

if [ "$1" == "add" ]; then
    # check if the configuration already exists in the interfaces file
    if grep -q "#Tor Whonix" /etc/network/interfaces; then
        echo "Error: Tor Whonix configuration already exists in interfaces file"
        exit 1
    else
        # add the configuration to the interfaces file
        sudo bash -c 'echo "#Tor Whonix" >> /etc/network/interfaces'
        sudo bash -c 'echo "auto eth0" >> /etc/network/interfaces'
        sudo bash -c 'echo "iface eth0 inet static" >> /etc/network/interfaces'
        sudo bash -c 'echo "address 10.152.152.12" >> /etc/network/interfaces'
        sudo bash -c 'echo "netmask 255.255.192.0" >> /etc/network/interfaces'
        sudo bash -c 'echo "gateway 10.152.152.10" >> /etc/network/interfaces'
        echo "Tor Whonix configuration added to interfaces file"
    fi
    if grep -q "nameserver 10.152.152.10" /etc/resolv.conf; then
        echo "Error: nameserver 10.152.152.10 already exists in resolv.conf file"
        exit 1
    else
        # add the nameserver configuration to the resolv.conf file
        if [ $# -lt 3 ]; then
            sudo bash -c 'sed -i "1i nameserver 9.9.9.9" /etc/resolv.conf'
            echo "nameserver 9.9.9.9 added to resolv.conf file"
        else
            sudo bash -c 'sed -i "1i nameserver $3" /etc/resolv.conf'
            echo "nameserver $3 added to resolv.conf file"
        fi
    fi
elif [ "$1" == "delete" ]; then
    # delete the configuration from the interfaces file
    sudo sed -i '/#Tor Whonix/,+5d' /etc/network/interfaces
    echo "Tor Whonix configuration deleted from interfaces file"
    # replace nameserver 10.152.152.10 with 9.9.9.9 or provided dns in the resolv.conf file
    if [ $# -lt 3 ]; then
    sudo sed -i 's/nameserver 10.152.152.10/nameserver 9.9.9.9/g' /etc/resolv.conf
    echo "nameserver 10.152.152.10 replaced with 9.9.9.9 in resolv.conf file"
else
    sudo sed -i "s/nameserver 10.152.152.10/nameserver $3/g" /etc/resolv.conf
    echo "nameserver 10.152.152.10 replaced with $3 in resolv.conf file"
fi
else
    echo "Error: invalid argument provided"
    display_help
    exit 1
fi
