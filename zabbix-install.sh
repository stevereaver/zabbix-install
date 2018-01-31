#!/usr/bin/bash
#
# Name:		zabbix-install.sh
# Authour:	Stephen Bancroft
# Date:		01/31/2018
# 
# Script to automate the installation of Zabbix agent on Solaris 11.3
# Run as root or sudo run it
#

# Check if running as root

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

## VARIABLES ##

HOSTNAME=`hostname`
FQDN=`host $HOSTNAME |cut -d' ' -f1`

## MAIN ##

groupadd -g 130 zabbix
useradd -u 130 -g 130 -c "Zabbix User" -s "/usr/bin/ksh" -m zabbix
mkdir /opt/zabbix
cd /opt/zabbix
wget https://www.zabbix.com/downloads/2.2.14/zabbix_agents_2.2.14.solaris10.sparc.tar.gz
tar -xvf zabbix_agents_2.2.14.solaris10.sparc.tar.gz
mkdir /opt/zabbix/log
chown -R zabbix:zabbix /opt/zabbix
rm -rf /opt/zabbix/conf
rm /opt/zabbix/zabbix_agents_2.2.14.solaris10.sparc.tar.gz
mkdir /etc/zabbix
sed -e 's/<HOSTNAME>/$FQDN/g' zabbix_agentd.dist
cp zabbix_agentd.conf.dist /etc/zabbix/zabbix_agent.conf 
chown -R zabbix:zabbix /etc/zabbix
cp zabbix.xml.dist /lib/svc/manifest/site
svcadm restart svc:/system/manifest-import:default 
svcs -a |grep zabbix
