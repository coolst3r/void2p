# void2p
a i2p ddos setup
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
