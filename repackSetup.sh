#!/bin/bash

echo "updating..."
sudo apt update -y --allow-releaseinfo-change & sudo apt upgrade -y

sudo cp ./wpa_supplicant.conf /etc/wpa_supplicant/
sudo raspi-config nonint do_hostname raspberrypi$1
