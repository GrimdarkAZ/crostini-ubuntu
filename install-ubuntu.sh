#!/bin/bash

apt update && apt upgrade -y

echo "deb https://storage.googleapis.com/cros-packages bullseye main" > /etc/apt/sources.list.d/cros.list
if [ -f /dev/.cros_milestone ]; then sudo sed -i "s?packages?packages/$(cat /dev/.cros_milestone)?" /etc/apt/sources.list.d/cros.list; fi
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4EB27DB2A3B88B8B
apt update

mkdir tmp
apt -d cros-ui-config
dpkg-deb -R cros-ui-config*.deb tmp
rm ./tmp/etc/gtk-3.0/settings.ini
sed -i '/\/etc\/gtk-3.0\/settings.ini/d' ./tmp/DEBIAN/conffiles
dpkg-deb -b tmp cros-ui-config-fixed.deb

apt install ./cros-ui-config-fixed.deb cros-guest-tools