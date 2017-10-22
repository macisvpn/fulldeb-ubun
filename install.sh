#!/bin/bash
# ******************************************
# Program: Autoscript Servis OrangKuatSabahanTerkini
# Website: OrangKuatSabahanTerkini.tk
# Developer: OrangKuatSabahanTerkini
# Nickname: OrangKuatSabahanTerkini
# Date: 22-07-2016
# Last Updated: 22-08-2017
# ******************************************
# MULA SETUP
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
if [ $USER != 'root' ]; then
echo "Sorry, for run the script please using root user"
exit 1
fi
if [[ "$EUID" -ne 0 ]]; then
echo "Sorry, you need to run this as root"
exit 2
fi
if [[ ! -e /dev/net/tun ]]; then
echo "TUN is not available"
exit 3
fi
echo "
AUTOSCRIPT BY OrangKuatSabahanTerkini
AMBIL PERHATIAN !!!"
clear
echo "MULA SETUP"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6
SILA TUNGGU SEDANG DI SETUP
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear
echo "
MEMBUANG SPAM PACKAGE
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update;
apt-get -y autoremove;
apt-get -y install wget curl;
echo "
"
# script
wget -O /etc/pam.d/common-password "http://autoscriptnobita.tk/rendum/common-password"
chmod +x /etc/pam.d/common-password
# fail2ban & exim & protection
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;

# webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "http://autoscriptnobita.tk/rendum/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

# squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://autoscriptnobita.tk/rendum/squid.conf"
wget -O /etc/squid/squid.conf "http://autoscriptnobita.tk/rendum/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid3/squid.conf
sed -i "s/ipserver/$myip/g" /etc/squid/squid.conf

# openvpn
apt-get -y install openvpn
wget -O /etc/openvpn/openvpn.tar "http://autoscriptnobita.tk/rendum/openvpn.tar"
cd /etc/openvpn/;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/rc.local "http://autoscriptnobita.tk/rendum/rc.local";chmod +x /etc/rc.local
#wget -O /etc/iptables.up.rules "http://rzvpn.net/random/iptables.up.rules"
#sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
#iptables-restore < /etc/iptables.up.rules

# text gambar
apt-get install boxes

# color text
cd
rm -rf /root/.bashrc
wget -O /root/.bashrc "https://raw.githubusercontent.com/samreysteven/newmenu/master/.bashrc"

# nginx
apt-get -y install nginx php-fpm php-mcrypt php-cli libexpat1-dev libxml-parser-perl
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/php/7.0/fpm/pool.d/www.conf "http://rzvpn.net/random/www.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Nobita95 | telegram @nobinobita95 | website autoscriptnobita.tk</pre>" > /home/vps/public_html/index.php
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://autoscriptnobita.tk/rendum/vps.conf"
sed -i 's/listen = \/var\/run\/php7.0-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/7.0/fpm/pool.d/www.conf

# etc
wget -O /home/vps/public_html/client.ovpn "http://autoscriptnobita.tk/rendum/client.ovpn"
wget -O /etc/motd "http://autoscriptnobita.tk/rendum/motd"
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
useradd -m -g users -s /bin/bash archangels
echo "7C22C4ED" | chpasswd
echo "UPDATE DAN INSTALL SIAP 99% MOHON SABAR"
cd;rm *.sh;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
clear

# download script
cd
wget -O /usr/bin/benchmark "https://raw.githubusercontent.com/samreysteven/newmenu/master/benchmark.sh"
wget -O /usr/bin/speedtest  "https://raw.githubusercontent.com/samreysteven/newmenu/master/speedtest_cli.py"
wget -O /usr/bin/ps-mem "https://raw.githubusercontent.com/samreysteven/newmenu/master/ps_mem.py"
wget -O /usr/bin/dropmon "https://raw.githubusercontent.com/samreysteven/newmenu/master/dropmon.sh"
wget -O /usr/bin/menu "https://raw.githubusercontent.com/samreysteven/newmenu/master/menu.sh"
wget -O /usr/bin/user-active-list "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-active-list.sh"
wget -O /usr/bin/user-add "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-add.sh"
wget -O /usr/bin/user-add-pptp "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-add-pptp.sh"
wget -O /usr/bin/user-del "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-del.sh"
wget -O /usr/bin/disable-user-expire "https://raw.githubusercontent.com/samreysteven/newmenu/master/disable-user-expire.sh"
wget -O /usr/bin/delete-user-expire "https://raw.githubusercontent.com/samreysteven/newmenu/master/delete-user-expire.sh"
wget -O /usr/bin/banned-user "https://raw.githubusercontent.com/samreysteven/newmenu/master/banned-user.sh"
wget -O /usr/bin/unbanned-user "https://raw.githubusercontent.com/samreysteven/newmenu/master/unbanned-user.sh"
wget -O /usr/bin/user-expire-list "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-expire-list.sh"
wget -O /usr/bin/user-gen "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-gen.sh"
wget -O /usr/bin/userlimit.sh "https://raw.githubusercontent.com/samreysteven/newmenu/master/userlimit.sh"
wget -O /usr/bin/userlimitssh.sh "https://raw.githubusercontent.com/samreysteven/newmenu/master/userlimitssh.sh"
wget -O /usr/bin/user-list "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-list.sh"
wget -O /usr/bin/user-login "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-login.sh"
wget -O /usr/bin/user-pass "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-pass.sh"
wget -O /usr/bin/user-renew "https://raw.githubusercontent.com/samreysteven/newmenu/master/user-renew.sh"
wget -O /usr/bin/clearcache.sh "https://raw.githubusercontent.com/samreysteven/newmenu/master/clearcache.sh"
wget -O /usr/bin/bannermenu "https://raw.githubusercontent.com/samreysteven/newmenu/master/bannermenu"
cd

#rm -rf /etc/cron.weekly/
#rm -rf /etc/cron.hourly/
#rm -rf /etc/cron.monthly/
rm -rf /etc/cron.daily/
wget -O /root/passwd "https://raw.githubusercontent.com/samreysteven/newmenu/master/passwd.sh"
chmod +x /root/passwd
echo "01 23 * * * root /root/passwd" > /etc/cron.d/passwd

echo "*/30 * * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "00 23 * * * root /usr/bin/disable-user-expire" > /etc/cron.d/disable-user-expire
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
#echo "00 01 * * * root echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a" > /etc/cron.d/clearcacheram3swap
echo "*/30 * * * * root /usr/bin/clearcache.sh" > /etc/cron.d/clearcache1

cd
chmod +x /usr/bin/benchmark
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/ps-mem
#chmod +x /usr/bin/autokill
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/menu
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-del
chmod +x /usr/bin/disable-user-expire
chmod +x /usr/bin/delete-user-expire
chmod +x /usr/bin/banned-user
chmod +x /usr/bin/unbanned-user
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/userlimit.sh
chmod +x /usr/bin/userlimitssh.sh
chmod +x /usr/bin/user-list
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-renew
chmod +x /usr/bin/clearcache.sh
chmod +x /usr/bin/bannermenu
cd

# restart service
service ssh restart
service openvpn restart
service dropbear restart
service nginx restart
service php7.0-fpm restart
service webmin restart
service squid restart
service fail2ban restart
clear
# SELASAI SUDAH BOSS! ( AutoscriptByOrangKuatSabahanTerkini )
echo "========================================"  | tee -a log-install.txt
echo "Service Autoscript OrangKuatSabahanTerkini (OrangKuatSabahanTerkini SCRIPT 2017)"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "nginx : http://$myip:80"   | tee -a log-install.txt
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt
echo "Squid3 : 8080"  | tee -a log-install.txt
echo "OpenSSH : 22"  | tee -a log-install.txt
echo "Dropbear : 443"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (SILA DAPATKAN DENGAN OrangKuatSabahanTerkini)"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Menu : type menu to check menu script"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------------------------------------"
echo "LOG INSTALL  --> /root/log-install.txt"
echo "----------------------------------------"
echo "========================================"  | tee -a log-install.txt
echo "      PLEASE REBOOT TO TAKE EFFECT !"
echo "========================================"  | tee -a log-install.txt
cat /dev/null > ~/.bash_history && history -c
