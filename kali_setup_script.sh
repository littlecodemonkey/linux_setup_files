#!/bin/bash
# Kali setup script


#---------------------------------------------------------------------------------------------------------------------------------------------------------
# PART ONE
# The Hacker Playbook 2 -- Basic install upgrade
# Remember to check http://thehackerplaybook.com/updates/ for any updates.
#---------------------------------------------------------------------------------------------------------------------------------------------------------


#######################################################################
# Global Variables
#######################################################################
set timeout 600
newpass="newpassword"
newhost="newhostname"
ipaddress= ip -4 -o addr show dev eth0 |awk '{split($4,a,"/") ;print a[1]}'|tr -d '\n'

# FIREFOX ADD-ONS
firefox https://addons.mozilla.org/en-US/firefox/addon/web-developer/
firefox https://addons.mozilla.org/en-US/firefox/addon/tamper-data/
firefox https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/
firefox https://addons.mozilla.org/en-US/firefox/addon/user-agent-switcher/


#######################################################################
# Change password
#######################################################################
echo "$newpass" | passwd --stdin


#######################################################################
# Update box
#######################################################################
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
echo "deb-src http://http.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list
apt-get -y update
apt-get install -y linux-headers-$(uname -r) python-pefile bdfproxy mitmproxy python-openssl openssl subversion python2.7-dev python git gcc make libpcap-dev python-elixir ldap-utils rwho rsh-client x11-apps finger w3m 


#######################################################################
# Set up postgres
#######################################################################
service postgresql start
update-rc.d postgresql enable


#######################################################################
# Set up metasploit
#######################################################################
msfupdate
msfdb init
msfdb start

/usr/bin/expect <<EOD
spawn msfconsole
expect "msf >"
send "exit\n" 
EOD

echo "spool /root/msf_console.log" > /root/.msf4/msfconsole.rc
echo "spool /root/msf_console.log" > /root/.msf5/msfconsole.rc 

#######################################################################
# Change hostname in /etc/hosts & /etc/hostname
#######################################################################
hostn=$(cat /etc/hostname)
sudo sed -i "s/$hostn/$newhost/g" /etc/hosts
sudo sed -i "s/$hostn/$newhost/g" /etc/hostname


#######################################################################
# Install backdoor factory
#######################################################################
git clone https://github.com/secretsquirrel/the-backdoor-factory /opt/the-backdoor-factory
cd /opt/the-backdoor-factory
/opt/the-backdoor-factory/install.sh

#Change all HOST IPs to your Kali IP
sudo sed -i "s/HOST = \d+\.\d+\.\d+/HOST = $ipaddress/g" /etc/bdfproxy/bdfproxy.cfg

bdfproxy

/usr/bin/expect <<EOD
spawn msfconsole -r /usr/share/bdfproxy/bdfproxy_msf_resource.rc
expect "msf >"
send "exit\n" 
EOD


# Arp Stuff:
# sysctl -w net.inet.ip_forwarding=1
# iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
# arpspoof -i eth0 -t victim-ip gateway-ip
# arpspoof -i eth0 -t gateway-ip victim-ip

#######################################################################
# HTTPScreenShot
# HTTPScreenshot is a tool for grabbing screenshots and HTML of large numbers of websites.
#######################################################################
pip install selenium
git clone https://github.com/breenmachine/httpscreenshot.git /opt/httpscreenshot
cd /opt/httpscreenshot
chmod +x install-dependencies.sh && /opt/httpscreenshot/install-dependencies.sh

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	echo "I'm 64-bit so no extra stuff here for HTTPScreenShot"
else
	echo "HTTPScreenShot only works if you are running on a 64-bit Kali by default. I'm running 32-bit PAE here, installing i686 phatomjs"
	wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-i686.tar.bz2
	bzip2 -d phantomjs-1.9.8-linux-i686.tar.bz2
	tar xvf phantomjs-1.9.8-linux-i686.tar
	cp phantomjs-1.9.8-linux-i686/bin/phantomjs /usr/bin/
fi


#######################################################################
# SMBExec
#######################################################################
git clone https://github.com/pentestgeek/smbexec.git /opt/smbexec
echo "******************Select 1 - Debian/Ubuntu and derviatives; Select all defaults, then select 4, followed by 5******************"
cd /opt/smbexec
/opt/smbexec/install.sh
/opt/smbexec/install.sh


#######################################################################
# Masscan
# This is the fastest Internet port scanner. It can scan the entire Internet in under six minutes.
#######################################################################
git clone https://github.com/robertdavidgraham/masscan.git /opt/masscan
cd /opt/masscan
make
make install


#######################################################################
# CMSmap
# CMSmap is a python open source CMS (Content Management System) scanner that automates the process of detecting security flaws
#######################################################################
git clone https://github.com/Dionach/CMSmap /opt/CMSmap


#######################################################################
# WPScan
# WordPress vulnerability scanner and brute-force tool
#######################################################################
git clone https://github.com/wpscanteam/wpscan.git /opt/wpscan
cd /opt/wpscan && ./wpscan.rb --update


#######################################################################
# Eyewitness
# EyeWitness is designed to take screenshots of websites, provide some server header info, and identify default credentials if possible.
#######################################################################
git clone https://github.com/ChrisTruncer/EyeWitness.git /opt/EyeWitness


#######################################################################
# Printer Exploits
# Contains a number of commonly found printer exploits
#######################################################################
git clone https://github.com/MooseDojo/praedasploit /opt/praedasploit


#######################################################################
# SQLMap
# SQL Injection tool
#######################################################################
git clone https://github.com/sqlmapproject/sqlmap /opt/sqlmap


#######################################################################
# Recon-ng
# A full-featured web reconnaissance framework written in Python
#######################################################################
git clone https://bitbucket.org/LaNMaSteR53/recon-ng.git /opt/recon-ng
pip install PyPDF2
pip install olefile


#######################################################################
# Discover Scripts
# Custom bash scripts used to automate various pentesting tasks.
#######################################################################
git clone https://github.com/leebaird/discover.git /opt/discover
cd /opt/discover && ./update.sh


#######################################################################
# Responder
# A LLMNR, NBT-NS and MDNS poisoner, with built-in HTTP/SMB/MSSQL/FTP/LDAP rogue authentication server supporting NTLMv1/NTLMv2/LMv2, Extended Security NTLMSSP and Basic HTTP authentication. Responder will be used to gain NTLM challenge/response hashes
#######################################################################
git clone https://github.com/SpiderLabs/Responder.git /opt/Responder


#######################################################################
# The Hacker Playbook 2 - Custom Scripts
# A number of custom scripts from The Hacker Playbook 2.
#######################################################################
git clone https://github.com/cheetz/Easy-P.git /opt/Easy-P
git clone https://github.com/cheetz/Password_Plus_One /opt/Password_Plus_One
git clone https://github.com/cheetz/PowerShell_Popup /opt/PowerShell_Popup
git clone https://github.com/cheetz/icmpshock /opt/icmpshock
git clone https://github.com/cheetz/brutescrape /opt/brutescrape
git clone https://www.github.com/cheetz/reddit_xss /opt/reddit_xss


#######################################################################
# The Hacker Playbook 2 - Forked Scripts
#######################################################################
git clone https://github.com/cheetz/PowerSploit /opt/HP_PowerSploit
git clone https://github.com/cheetz/PowerTools /opt/HP_PowerTools


#######################################################################
# DSHashes:
# Extracts user hashes in a user-friendly format for NTDSXtract
#######################################################################
wget http://ptscripts.googlecode.com/svn/trunk/dshashes.py -O /opt/NTDSXtract/dshashes.py


#######################################################################
# SPARTA:
# A python GUI application which simplifies network infrastructure penetration testing by aiding the penetration tester in the scanning and enumeration phase.
#######################################################################
git clone https://github.com/secforce/sparta.git /opt/sparta


#######################################################################
# NoSQLMap
# A automated pentesting toolset for MongoDB database servers and web applications.
#######################################################################
git clone https://github.com/tcstool/NoSQLMap.git /opt/NoSQLMap


#######################################################################
# Spiderfoot
# Open Source Footprinting Tool
#######################################################################
mkdir /opt/spiderfoot/ && cd /opt/spiderfoot
wget http://sourceforge.net/projects/spiderfoot/files/spiderfoot-2.3.0-src.tar.gz/download
tar xzvf download
pip install lxml
pip install netaddr
pip install M2Crypto
pip install cherrypy
pip install mako


#######################################################################
# WCE
# Windows Credential Editor (WCE) is used to pull passwords from memory
#######################################################################
mkdir /opt/wce && cd /opt/wce
wget http://www.ampliasecurity.com/research/wce_v1_41beta_universal.zip
unzip wce_v1* -d /opt/wce && rm wce_v1*.zip


#######################################################################
# Mimikatz
# Used for pulling cleartext passwords from memory, Golden Ticket, skeleton key and more
#######################################################################
cd /opt/ && wget http://blog.gentilkiwi.com/downloads/mimikatz_trunk.zip
unzip -d ./mimikatz mimikatz_trunk.zip
rm -f mimikatz_trunk.zip


#######################################################################
# SET
# Social Engineering Toolkit (SET) will be used for the social engineering campaigns
#######################################################################
git clone https://github.com/trustedsec/social-engineer-toolkit/ /opt/set/
cd /opt/set && ./setup.py install


#######################################################################
# PowerSploit (PowerShell)
# PowerShell scripts for post exploitation
#######################################################################
git clone https://github.com/mattifestation/PowerSploit.git /opt/PowerSploit
cd /opt/PowerSploit && wget https://raw.githubusercontent.com/obscuresec/random/master/StartListener.py && wget https://raw.githubusercontent.com/darkoperator/powershell_scripts/master/ps_encoder.py


#######################################################################
# Nishang (PowerShell)
# Collection of PowerShell scripts for exploitation and post exploitation
#######################################################################
git clone https://github.com/samratashok/nishang /opt/nishang


#######################################################################
# Veil-Framework
# A red team toolkit focused on evading detection. It currently contains Veil-Evasion for generating AV-evading payloads, Veil-Catapult for delivering them to targets, and Veil-PowerView for gaining situational awareness on Windows domains. Veil will be used to create a python based Meterpreter executable.
#######################################################################
git clone https://github.com/Veil-Framework/Veil /opt/Veil
cd /opt/Veil/ && ./Install.sh -c


#######################################################################
# Fuzzing Lists (SecLists)
# These are scripts to use with Burp to fuzz parameters
#######################################################################
git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists
	

#######################################################################	
# Net-Creds Network Parsing 
# Parse PCAP files for username/passwords
#######################################################################
git clone https://github.com/DanMcInerney/net-creds.git /opt/net-creds	


#######################################################################
# Wifite
# Attacks against WiFi networks
#######################################################################
git clone https://github.com/derv82/wifite /opt/wifite


#######################################################################
# WIFIPhisher
# Automated phishing attacks against WiFi networks
#######################################################################
git clone https://github.com/sophron/wifiphisher.git /opt/wifiphisher


#######################################################################
# Phishing (Optional):
# Phishing-Frenzy
#######################################################################
git clone https://github.com/pentestgeek/phishing-frenzy.git /var/www/phishing-frenzy
# Custom List of Extras
git clone https://github.com/macubergeek/gitlist.git /opt/gitlist


#######################################################################
# Gitrob
# Reconnaissance tool for GitHub organizations /opt
#######################################################################
git clone https://github.com/michenriksen/gitrob.git /opt/gitrob
gem install bundler
service postgresql start
cd /opt/gitrob/bin
gem install gitrob


#######################################################################
# BeEF Exploitation Framework
# A cross-site scripting attack framework
#######################################################################
cd /opt/
wget https://raw.github.com/beefproject/beef/a6a7536e/install-beef
chmod +x install-beef
/opt/install-beef
echo "******************Press control-c enter to save the file then q to exit******************"


#---------------------------------------------------------------------------------------------------------------------------------------------------------
# PART TWO
# Some Other Stuff -- Based off jivoi https://github.com/jivoi suggestions
#---------------------------------------------------------------------------------------------------------------------------------------------------------


#######################################################################
# Unicorn
# Unicorn is a simple tool for using a PowerShell downgrade attack and inject shellcode straight into memory.
#######################################################################
git clone https://github.com/trustedsec/unicorn /opt/unicorn


#######################################################################
# Free RADIUS server
# AAA Server
#######################################################################
cd /opt
wget ftp://ftp.freeradius.org/pub/freeradius/old/freeradius-server-2.1.12.tar.bz2
tar xfj freeradius-server-2.1.12.tar.bz2 && rm -f freeradius-server-2.1.12.tar.bz2 && mv freeradius-server-2.1.12 freeradius-server && cd freeradius-server
wget https://raw.githubusercontent.com/brad-anton/freeradius-wpe/master/freeradius-wpe.patch
patch -p1 < freeradius-wpe.patch
./configure && make && make install


#######################################################################
# peCloak
# An Experiment in AV Evasion
#######################################################################
cd /opt && mkdir peCloak && cd peCloak
wget http://www.securitysift.com/download/peCloak.py
wget https://gist.githubusercontent.com/anonymous/420ab3bf69e4d5e1f833/raw/d598b65da5188676c7e43663d98ffb6ada95d2a8/SectionDoubleP.py


#######################################################################
# WinAppDbg
# The WinAppDbg python module allows developers to quickly code instrumentation scripts in Python under a Windows environment.
#######################################################################
cd /tmp
echo "******************Press enter to save the file then q to exit******************"
w3m Download http://sourceforge.net/projects/winappdbg/files/latest/download
unzip winappdbg-1.5.zip
cd winappdbg-1.5
python setup.py install


#######################################################################
# PYDASM
# Python disassembler for disassembling executable code
#######################################################################
svn checkout http://libdasm.googlecode.com/svn/trunk/ /tmp/libdasm
cd /tmp/libdasm
make
make install
cd pydasm
python setup.py build_ext
sudo python setup.py install


#---------------------------------------------------------------------------------------------------------------------------------------------------------
# PART THREE
# Stuff I like
#---------------------------------------------------------------------------------------------------------------------------------------------------------


#######################################################################
# Generic apt-get
#######################################################################


#######################################################################
# Burp Suite Free
# Web app security testing toolset
#######################################################################
mkdir /opt/burp
cd /opt/burp
wget -O burpsuite.jar https://portswigger.net/DownloadUpdate.ashx?Product=Free


#######################################################################
# SourceCodePro
# My Favorite Font
#######################################################################
FONT_NAME="SourceCodePro"
URL="http://sourceforge.net/projects/sourcecodepro.adobe/files/latest/download"
mkdir /tmp/adodefont
cd /tmp/adodefont
wget ${URL} -O ${FONT_NAME}.zip
unzip -o -j ${FONT_NAME}.zip
mkdir -p ~/.fonts
cp *.otf ~/.fonts
fc-cache -f -v



#---------------------------------------------------------------------------------------------------------------------------------------------------------
# PART FOUR
# Finish prostgres setup
#---------------------------------------------------------------------------------------------------------------------------------------------------------


#######################################################################
# POSTGRES 
# Create user
# END OF FILE
#######################################################################
su - postgres
createuser -s gitrob
createdb -O gitrob gitrob
exit
