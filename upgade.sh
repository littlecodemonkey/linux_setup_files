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
git -C '/opt/icmpshock/' pull
git -C '/opt/beef/' pull
git -C '/opt/SecLists/' pull
git -C '/opt/gitlist/' pull
git -C '/opt/sqlmap/' pull
git -C '/opt/wifite/' pull
git -C '/opt/masscan/' pull
git -C '/opt/gitrob/' pull
git -C '/opt/wifiphisher/' pull
git -C '/opt/Password_Plus_One/' pull
git -C '/opt/Responder/' pull
git -C '/opt/NoSQLMap/' pull
git -C '/opt/recon-ng/' pull
git -C '/opt/net-creds/' pull
git -C '/opt/sparta/' pull
git -C '/opt/wpscan/' pull
git -C '/opt/EyeWitness/' pull
git -C '/opt/PowerShell_Popup/' pull
git -C '/opt/PowerSploit/' pull
git -C '/opt/discover/' pull
git -C '/opt/HP_PowerSploit/' pull
git -C '/opt/set/' pull
git -C '/opt/Easy-P/' pull
git -C '/opt/unicorn/' pull
git -C '/opt/praedasploit/' pull
git -C '/opt/HP_PowerTools/' pull
git -C '/opt/nishang/' pull
git -C '/opt/httpscreenshot/' pull
git -C '/opt/the-backdoor-factory/' pull
git -C '/opt/reddit_xss/' pull
git -C '/opt/brutescrape/' pull
git -C '/opt/smbexec/' pull
git -C '/opt/CMSmap/' pull
git -C '/opt/Veil/' pull
git -C '/opt/Veil/Veil-Pillage/' pull
git -C '/opt/Veil/PowerTools/' pull
git -C '/opt/Veil/Veil-Catapult/' pull
git -C '/opt/Veil/Veil-Ordnance/' pull
git -C '/opt/Veil/Veil-Evasion/' pull
