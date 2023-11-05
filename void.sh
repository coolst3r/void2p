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
