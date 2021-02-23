#!/bin/bash

echo "setting Raspberry Pi..."
sudo raspi-config nonint do_change_timezone Asia/Tokyo
sudo raspi-config nonint do_change_locale ja_JP.UTF-8
sudo raspi-config nonint do_wifi_country JP
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0

echo "updating..."
sudo apt update -y & sudo apt upgrade -y

echo "install tools..."
sudo apt install -y emacs pigpio

yes | bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
sudo systemctl enable nodered.service

sudo apt install hostapd dnsmasq -y
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo -e "\ninterface wlan0\n\tstatic ip_address=192.168.4.1/24\n\tnohook wpa_supplicant" | sudo tee -a /etc/dhcpcd.conf
sudo echo -e "\ninterface=wlan0\ndhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h\ndomain=wlan\naddress=/gw.wlan/192.168.4.1" | sudo tee -a /etc/dnsmasq.conf

cat << EOS | sudo tee /etc/hostapd/hostapd.conf
country_code=JP
interface=wlan0
ssid=raspi-settings
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOS

