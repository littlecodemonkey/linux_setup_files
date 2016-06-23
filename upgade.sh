#!/bin/bash

# apt-get
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get clean
apt-get autoclean
apt-get update
apt-get upgrade -y

# Metasploit update
msfupdate

# GIT UPDATES
cd /opt/icmpshock/; git pull;
cd /opt/beef/; git pull;
cd /opt/SecLists/; git pull;
cd /opt/gitlist/; git pull;
cd /opt/sqlmap/; git pull;
cd /opt/wifite/; git pull;
cd /opt/masscan/; git pull;
cd /opt/gitrob/; git pull;
cd /opt/wifiphisher/; git pull;
cd /opt/Password_Plus_One/; git pull;
cd /opt/Responder/; git pull;
cd /opt/NoSQLMap/; git pull;
cd /opt/recon-ng/; git pull;
cd /opt/net-creds/; git pull;
cd /opt/sparta/; git pull;
cd /opt/wpscan/; git pull;
cd /opt/EyeWitness/; git pull;
cd /opt/PowerShell_Popup/; git pull;
cd /opt/PowerSploit/; git pull;
cd /opt/discover/; git pull;
cd /opt/HP_PowerSploit/; git pull;
cd /opt/set/; git pull;
cd /opt/Easy-P/; git pull;
cd /opt/unicorn/; git pull;
cd /opt/praedasploit/; git pull;
cd /opt/HP_PowerTools/; git pull;
cd /opt/nishang/; git pull;
cd /opt/httpscreenshot/; git pull;
cd /opt/the-backdoor-factory/; git pull;
cd /opt/reddit_xss/; git pull;
cd /opt/brutescrape/; git pull;
cd /opt/smbexec/; git pull;
cd /opt/CMSmap/; git pull;
cd /opt/Veil/; git pull;
cd /opt/Veil/Veil-Pillage/; git pull;
cd /opt/Veil/PowerTools/; git pull;
cd /opt/Veil/Veil-Catapult/; git pull;
cd /opt/Veil/Veil-Ordnance/; git pull;
cd /opt/Veil/Veil-Evasion/; git pull;
