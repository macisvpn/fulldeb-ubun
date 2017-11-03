#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

flag=0


echo


if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi


while :
do
	#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
	#if [ "$MYIP" = "" ]; then
		#MYIP=$(wget -qO- ipv4.icanhazip.com)
	#fi

	clear
    echo ""
	echo -e "\e[0;36m------------------- Welcome To CuCu AtoK Autoscript -------------------\e[0;0m"
	echo -e "\e[0;31m                      :ID TeLeGraM: @CuCu_Atok "
    echo ""
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
	echo -e "\e[0;33mCPU model             :\e[32m $cname"
	echo -e "\e[0;33mNumber of cores       : \e[32m $cores"
	echo -e "\e[0;33mCPU frequency         :\e[32m $freq MHz"
	echo -e "\e[0;33mTotal amount of ram   : \e[32m $tram MB"
	echo -e "\e[0;33mTotal amount of swap  : \e[32m $swap MB"
	echo -e "\e[0;33mSystem uptime         :\e[32m$up"
    echo ""
	echo -e "\e[0;36m------------------------------------------------------------------------\e[0;0m"
	echo "                     Please Type 'menu' After Each Mission "
    echo -e "\e[0;36m------------------------------------------------------------------------\e[0;0m"
    echo ""
	echo -e "\e[0;35m 1)\e[0m Create new user                          (name, pass, days)"
    echo -e "\e[0;35m 2)\e[0m User renew                               (name, days extend)"
	echo -e "\e[0;35m 3)\e[0m User password change                     (change pass of user)"
	echo -e "\e[0;35m 4)\e[0m User delete                              (delete account)"
    echo -e "\e[0;35m 5)\e[0m User details                             (user-list)"
    echo -e "\e[0;35m 6)\e[0m Check user expire                        (user-expire-list)"
    echo -e "\e[0;35m 7)\e[0m Generate new user                        (quick create user-pass)"
	echo -e "\e[0;35m 8)\e[0m Create account PPTP VPN                  (user-add-pptp)"
	echo -e "\e[0;35m 9)\e[0m Monitoring Dropbear                      (dropmon by port)"
	echo -e "\e[0;35m10)\e[0m Check Login Dropbear, SSH, VPN, PPTP     (user-login)"
	echo -e "\e[0;35m11)\e[0m Kill Multi Login Manual (1 or 2 Login)   (user-limit)"
	echo -e "\e[0;35m12)\e[0m Restart Dropbear                         (service dropbear restart)"
	echo -e "\e[0;35m13)\e[0m Memory Usage                             (ram-usage)"
	echo -e "\e[0;35m14)\e[0m Speedtest                                (speedtest)"
	echo -e "\e[0;35m15)\e[0m Benchmark                                (benchmark)"
    echo -e "\e[0;35m16)\e[0m Update script                            (check new cript)"
    echo -e "\e[0;35m17)\e[0m Download client                          (client config)"
    echo -e "\e[0;35m18)\e[0m Change root password                     (vps-password change)"
    echo -e "\e[0;35m19)\e[0m Buy Autoscript                           (order autoscript)"
    echo -e "\e[0;35m20)\e[0m Reboot Server                            (reboot)"
	echo -e "\e[0;35m21)\e[0m Exit                                     (Back)"	
	echo ""
	read -p "Select an option from [1-21] than press ENTER: " option1
	case $option1 in
		1)
		clear
		user-add
		exit
		;;
		2)
		clear
		user-renew
		exit
		;;
		3)
		clear
		user-pass
		exit
		;;
		4)
		clear
		user-del
		exit
		;;
		5)
		clear
		user-list
		exit
		;;
		6)
		clear
echo ""    
echo -e "\e[0;36m------------Expried List--------------\e[0;0m" 
echo ""   
		user-expire
echo ""  
echo -e "\e[0;35m÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ooAAAoo÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷\e[0;0m"       
echo -e "\e[0;0mIf have user expired systems will show\e[0;0m"
echo -e "\e[0;36m÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ooAAAoo÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷\e[0;0m" 
echo -e "\e[0;0m     Thank you for choice us\e[0;0m" 
echo ""
		exit
		;;
		7)
		clear
		user-gen
		exit
		;;
		8)
		clear
		user-add-pptp
		exit
		;;
		9)
		clear
		read -p "What dropbear port number you want check?: " PORT
		dropmon $PORT
		exit
		;;
		10)
		clear
		user-login
		exit
		;;
		11)
		clear
		read -p "How many user allow login? (1-2): " MULTILOGIN
		user-limit $MULTILOGIN
                echo "Done."
                echo ""
		exit
		;;
		12)
		clear
        echo -e "\e[0;31m Service Dropbear going Restart NOW.......  \e[0;0m"
		service dropbear restart
		exit
		;;
		13)
		clear
		ps-mem
		exit
		;;
		14)
		clear
		speedtest
		exit
		;;
		15)
		clear
		benchmark
		exit
		;;
		16)
		clear
echo -e "\e[0;36m
-------------------- UPDATE AUTO VERSION ----------------\e[0;0m"
    echo ""
        echo -e "\e[0;33m
UPDATE LOADING..............................................
LATEST VERSION 2017
NO UPDATE LATEST
THANK YOU
\e[0;0m"
		exit
		;;
		17)
		clear
        echo -e "\e[0;36m---------------------------------------\e[0;0m" 
        echo "Download your OpenVPN client config  "
        echo -e "\e[0;36m---------------------------------------\e[0;0m" 
        echo ""
		echo -e "\e[0;31m  http://$MYIP/client.ovpn\e[0;0m"
        echo ""
		exit
		;;
        18)
		clear
        passwd
		exit
		;;
        19)
		clear
        echo -e "\e[0;36m
-------------------- WELCOME @_@ ----------------\e[0;0m"
    echo ""
        echo -e "\e[0;33m
CUCU_ATOK AUTOSCRIPT (Centos-Debian-Ubuntu)
Tel :+60175835809 Sms/whatsapp/telegram 
http://Panel.cucuatok.jumpingcrab.com
http://telegram.me/CuCu_Atok
\e[0;0m"
        echo -e "\e[0;36m
-------------------------------------------------
Vps setup Panel reseller, Webmin, Openvpn    
Script for sell: Centos, Debian, Ubuntu
Panel reseller, Webmin, Openvpn, Proxy, Dropbear 
-------------------------------------------------
\e[0;0m" 
       echo -e "\e[0;35m 
PAYMENT OPTIONS
Maybank:159013087957 HAFIEZAN ABD HAMID
 \e[0;0m"
   echo -e "\e[0;34m 
Price list
Setup Rm30/ip, Rm100 VPS full autoscript.
               \e[0;0m"
		exit
		;;
       20)
		clear
        echo -e "\e[0;31m The system going to reboot NOW.......  \e[0;0m"
        reboot
		exit
		;;
        21)
		clear
		exit
		;;
	esac
done

cd ~/
rm -f /root/IP
