#!/bin/bash

echo "updating..."
sudo apt update & sudo apt upgrade -y

echo "setting Raspberry Pi..."
sudo raspi-config nonint do_change_timezone Asia/Tokyo
sudo raspi-config nonint do_change_locale ja_JP.UTF-8
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0

echo "install tools..."
sudo apt install -y git emacs pigpio

echo "install nodejs&nodered"
sudo apt install -y nodejs npm
sudo npm install n -g
sudo n stable
sudo apt purge -y nodejs npm
