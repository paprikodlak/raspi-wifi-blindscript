#! /bin/sh

# raspi-wifi-blindscript v4
#   A minimium command line script to configure Wi-Fi network on Raspbian 
#   system for Raspberry Pi(R) ARM computer. 
# Project HP: https://github.com/shamiao/raspi-wifi-blindscript
#
# Copyright (C) 2013 Sha Miao
# This program is released under the MIT license,
# see <http://opensource.org/licenses/MIT> for full text.
#
# raspi-wifi-shellscript v1.
# Edited 2016 by Vít Pawlik
# sudo chmod +x raspi-wifi-shellscript.sh 
# to make executable.
# run with sudo ./raspi-wifi-shellscript.sh
# 
# script will ask for wifi settings and then set it up. 


# SSID (aka. network name).
echo -n "Enter SSID name (or press [ENTER] to exit):"
read SSID


if [ -z "$SSID" ]; then   #if variable SSID is empty
   printf '%s\n' "exited."
   exit 1
fi

# Network encryption method.
# * 'WPA' for WPA-PSK/WPA2-PSK;
# * 'WEP' for WEP;
# * 'Open' for open network (aka. no password).
echo -n "Enter encryption type (WPA for WPA-PSK/WPA2-PSK, WEP or Open):"
read ENCRYPTION

if [ -z "$ENCRYPTION" ]; then
   printf '%s\n' "exited."
   exit 1
fi

# Network password. (WPA-PSK/WPA2-PSK password, or WEP key)
echo -n "Enter password:"
read PASSWORD

if [ -z "$PASSWORD" ]; then
   printf '%s\n' "exited."
   exit 1
fi


###############################################################
####################       DONT EDIT       ####################
###############################################################

if [ $(id -u) -ne 0 ]; then
  printf "This script must be run as root. \n"
  exit 1
fi

NETID=$(wpa_cli add_network | tail -n 1)
wpa_cli set_network $NETID ssid \"$SSID\"
case $ENCRYPTION in
'WPA')
    wpa_cli set_network $NETID key_mgmt WPA-PSK
    wpa_cli set_network $NETID psk \"$PASSWORD\"
    ;;
'WEP')
    wpa_cli set_network $NETID wep_key0 $PASSWORD
    wpa_cli set_network $NETID wep_key1 $PASSWORD
    wpa_cli set_network $NETID wep_key2 $PASSWORD
    wpa_cli set_network $NETID wep_key3 $PASSWORD
    ;;
*)
    ;;
esac
wpa_cli enable_network $NETID
wpa_cli save_config
