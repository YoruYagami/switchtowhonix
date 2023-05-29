<h1 align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-23a82c">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/YoruYagami/switchtowhonix">
  <img src="https://img.shields.io/badge/Developed%20for-kali%20linux-blueviolet">
</h1>

# SwitchToWhonix

SwitchToWhonix is a bash script that allows you to easily manage your Tor Whonix network configuration on your Linux system.
The script provides a simple menu to let you add, delete, or view the status of the Tor Whonix configuration in your network interfaces file (/etc/network/interfaces).

## Usage
```
sudo ./switchtowhonix.sh
                .__  __         .__     __                .__                  .__        
  ________  _  _|__|/  |_  ____ |  |___/  |_  ______  _  _|  |__   ____   ____ |__|__  ___
 /  ___/\ \/ \/ /  \   __\/ ___\|  |  \   __\/  _ \ \/ \/ /  |  \ /  _ \ /    \|  \  \/  /
 \___ \  \     /|  ||  | \  \___|   Y  \  | (  <_> )     /|   Y  (  <_> )   |  \  |>    < 
/____  >  \/\_/ |__||__|  \___  >___|  /__|  \____/ \/\_/ |___|  /\____/|___|  /__/__/\_ \
     \/                       \/     \/                        \/            \/         \/
                                                                    By YoruYagami


 Select an option from menu:


Key      Menu Option:
---      -------------------------

 1    -  Add Tor Whonix configuration
 2    -  Delete Tor Whonix configuration
 3    -  View Tor Whonix status

 4    -  Check if Tor service is up and running and start if not
 5    -  Install Tor and Tor Browser

Enter your choice:
```

## Installation
```bash
  git clone https://github.com/YoruYagami/switchtowhonix.git
  cd switchtowhonix
  chmod +x ./switchtowhonix.sh
  sudo ./switchtowhonix.sh
```