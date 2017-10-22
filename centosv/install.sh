#!/bin/bash

# initialisasi var
OS=`uname -p`;

# go to root
cd

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

# install wget and curl
yum -y install wget curl

# setting repo
wget http://script.fawzya.net/centos/app/epel-release-6-8.noarch.rpm
wget http://script.fawzya.net/centos/app/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

if [ "$OS" == "x86_64" ]; then
  wget http://script.fawzya.net/centos/app/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
else
  wget http://script.fawzya.net/centos/app/rpmforge.rpm
  rpm -Uvh rpmforge.rpm
fi

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm

# remove unused
yum -y remove sendmail;
yum -y remove httpd;
yum -y remove cyrus-sasl

# update
yum -y update

# install webserver
yum -y install nginx php-fpm php-cli
service nginx restart
service php-fpm restart
chkconfig nginx on
chkconfig php-fpm on

# install essential package
yum -y install rrdtool screen iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum -y groupinstall 'Development Tools'
yum -y install cmake

yum -y --enablerepo=rpmforge install axel sslh ptunnel unrar

# matiin exim
service exim stop
chkconfig exim off

# setting vnstat
vnstat -u -i venet0
echo "MAILTO=root" > /etc/cron.d/vnstat
echo "*/5 * * * * root /usr/sbin/vnstat.cron" >> /etc/cron.d/vnstat
sed -i 's/eth0/venet0/g' /etc/sysconfig/vnstat
service vnstat restart
chkconfig vnstat on



# text gambar
yum install boxes

# color text
cd
rm -rf /root/.bashrc
wget -O /root/.bashrc "https://raw.githubusercontent.com/samreysteven/newmenu/master/.bashrc"

# install webserver
cd
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/nginx.conf"
sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf
mkdir -p /home/vps/public_html
echo "<pre>Setup by Fawzya.Net</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
rm /etc/nginx/conf.d/*
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/vps.conf"
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
chmod -R +rx /home/vps
service php-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/1194-centos.conf"
if [ "$OS" == "x86_64" ]; then
  wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/1194-centos64.conf"
fi
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
MYIP=`dig +short myip.opendns.com @resolver1.opendns.com`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
service openvpn restart
chkconfig openvpn on
cd

# configure openvpn client config
cd /etc/openvpn/
wget -O /etc/openvpn/1194-client.ovpn "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/open-vpn.conf"
sed -i $MYIP2 /etc/openvpn/1194-client.ovpn;
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -M -s /bin/false Fawzya
echo "Fawzya:$PASS" | chpasswd
echo "Fawzya" > pass.txt
echo "$PASS" >> pass.txt
tar cf client.tar 1194-client.ovpn pass.txt
cp client.tar /home/vps/public_html/
cp 1194-client.ovpn /home/vps/public_html/
cd

# install badvpn
wget -O /usr/bin/badvpn-udpgw "http://script.fawzya.net/centos/conf/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://script.fawzya.net/centos/conf/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
cd /etc/snmp/
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
service snmpd restart
chkconfig snmpd on
snmpwalk -v 1 -c public localhost | tail
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg/mrtg.cfg public@localhost
curl "http://script.fawzya.net/centos/conf/mrtg.conf" >> /etc/mrtg/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg/mrtg.cfg
echo "0-59/5 * * * * root env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg" > /etc/cron.d/mrtg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
cd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install dropbear
yum -y install dropbear
echo "OPTIONS=\"-p 109 -p 110 -p 443\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart
chkconfig dropbear on

# install vnstat gui
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install squid
yum -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/macisvpn/fulldeb-ubun/master/centosv/squid-centos.conf"

sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart
chkconfig squid on


# install webmin
cd
wget http://script.fawzya.net/centos/app/webmin-1.670-1.noarch.rpm
rpm -U webmin-1.670-1.noarch.rpm
rm webmin-1.670-1.noarch.rpm
service webmin restart
chkconfig webmin on

# pasang bmon
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/bmon "http://script.fawzya.net/centos/conf/bmon64"
else
  wget -O /usr/bin/bmon "http://script.fawzya.net/centos/conf/bmon"
fi
chmod +x /usr/bin/bmon

# block abuse
cd
wget script.fawzya.net/centos/block-abuse.sh
chmod +x block-abuse.sh
bash block-abuse.sh

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

# cron
service crond start
chkconfig crond on
service crond stop
echo "0 */12 * * * root /usr/bin/userexpire" > /etc/cron.d/user-expire
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear

# finalisasi
chown -R nginx:nginx /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service sshd restart
service dropbear restart
service fail2ban restart
service squid restart
service webmin restart
service crond start
chkconfig crond on

# info
clear
echo "Informasi Penggunaan SSH" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Layanan yang diaktifkan"  | tee -a log-install.txt
echo "--------------------------------------"  | tee -a log-install.txt
echo "OpenVPN : TCP 1194 (client config : http://$MYIP/1194-client.ovpn)"  | tee -a log-install.txt
echo "Port OS : 22, 143"  | tee -a log-install.txt
echo "Port Dropbear : 109, 110, 443"  | tee -a log-install.txt
echo "SquidProxy    : 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "Script tersedia"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt

echo "speedtest --share : untuk cek speed vps"  | tee -a log-install.txt
echo "userlog  : untuk melihat user yang sedang login"  | tee -a log-install.txt
echo "trial : untuk membuat akun trial selama 1 hari"  | tee -a log-install.txt
echo "usernew : untuk membuat akun baru"  | tee -a log-install.txt
echo "userlist : untuk melihat daftar akun beserta masa aktifnya"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt


echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
rm ovz-install.sh
reboot
