# SwitchToWhonix

This script allows users to add or delete the Tor Whonix configuration on their Linux system, and to specify a custom DNS server or use the default one. The script includes error handling for cases where the configuration or nameserver already exist, and also includes a help message for user guidance.

## How it works
When the script is executed, it first defines a function display_help() that outputs the usage instructions and help messages. If the user runs the script without providing any arguments or with the argument --help, the help message is displayed.

The script takes three arguments: add or delete, --help, and a DNS server address. The add option adds the Tor Whonix configuration to the interfaces and resolv.conf files, while the delete option removes the Tor Whonix configuration and replaces the nameserver 10.152.152.10 with 9.9.9.9 or a provided DNS server address in the resolv.conf file.

When the add option is chosen, the script first checks if the Tor Whonix configuration already exists in the interfaces file. If the configuration is not present, the script adds the necessary configuration lines to the interfaces file. It then checks if the nameserver configuration for 10.152.152.10 already exists in the resolv.conf file. If the configuration is not present, the script adds the necessary nameserver configuration line to the resolv.conf file with a default value of 9.9.9.9 or the DNS server address provided as an argument.

When the delete option is chosen, the script first removes the Tor Whonix configuration from the interfaces file. It then replaces the nameserver configuration for 10.152.152.10 with either 9.9.9.9 or the provided DNS server address in the resolv.conf file.

## Usage

1. Clone the repo
   ```sh
   git clone https://github.com/YoruYagami/switchtowhonix.git
   ```
2. Go to the project directory
   ```sh
   cd switchtowhonix
   ```
3. Change Permission
   ```sh
   chmod +x switchtowhonix.sh
   ```
4. Execute
   ```sh
   ./switchtowhonix.sh <argument>
   ```
