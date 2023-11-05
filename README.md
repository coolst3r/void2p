# void2p
a i2p ddos setup


a bash script that sets up a SOCKS-like proxy for the I2P network on Arch Linux and Debian systems. It uses the Dante SOCKS server and assumes you have already installed I2P.

bash

#!/bin/bash

# Check if the script is running with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit 1
fi

# Check if the operating system is supported (Arch Linux or Debian)
if [ -f /etc/arch-release ]; then
  # Arch Linux
  pacman -Sy --noconfirm dante
  systemctl enable danted
  systemctl start danted
elif [ -f /etc/debian_version ]; then
  # Debian
  apt-get update
  apt-get install -y dante-server
  systemctl enable danted
  systemctl start danted
else
  echo "Unsupported operating system"
  exit 1
fi

# Configure Dante SOCKS server
cat <<EOF > /etc/danted.conf
logoutput: stderr
internal: 0.0.0.0 port = 1080
external: eth0
socksmethod: username none
clientmethod: none
user.privileged: root
user.unprivileged: nobody
client pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  log: error connect disconnect
}
socks pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  command: bind connect udpassociate
  log: error connect disconnect
}
EOF

# Restart Dante SOCKS server
systemctl restart danted

echo "SOCKS-like proxy for I2P is now running on port 1080"


Make sure to run the script as root or with sudo privileges. The script will install the Dante SOCKS server, configure it to listen on port 1080, and start the server. It also handles the installation and configuration differences between Arch Linux and Debian.

Please note that this script assumes you have a network interface named "eth0". If your network interface has a different name, make sure to update the "external" line in the Dante configuration accordingly.

Remember to review and understand the script before running it, as it modifies system files and starts a network service. It's always a good practice to backup your system before making any changes.











1:
Install Proxychains:

    On Arch Linux:
pacman -Sy --noconfirm proxychains-ng i2p

On Debian:
    apt-get update
    apt-get install -y proxychains i2p

2:
Configure Proxychains:

    Open the Proxychains configuration file using a text editor:
nano /etc/proxychains.conf

Uncomment the dynamic_chain and proxy_dns lines by removing the '#' symbol at the beginning of each line.
Replace the existing socks4 127.0.0.1 9050 line with the following line:
    socks5 127.0.0.1 1080
Use Proxychains:
    Run any application through Proxychains by prefixing the command with proxychains:
    b
proxychains <command>

For example, to run curl through Proxychains:

arduino

        proxychains curl http://example.com

Proxychains will now force the specified application to route its traffic through the Dante SOCKS proxy running on port 1080.
