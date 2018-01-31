#!/usr/bin/bash
#
# Name:         zabbix-remove.sh
# Authour:      Stephen Bancroft
# Date:         01/31/2018
# 
# Script to automate the removal of Zabbix agent on Solaris 11.3
# Run as root or sudo run it
#

# Check if running as root

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# We can't really delete an SMF on Solaris, so we will just disable it.
svcadm disable zabbix_agent

if [ -d "/etc/zabbix" ]; then
  rm -rf /etc/zabbix
fi

if [ -d "/opt/zabbix" ]; then
  rm -rf /opt/zabbix
fi

groupdel zabbix
userdel zabbix
