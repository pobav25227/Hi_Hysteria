#!/bin/bash
hihyV="0.4.9"
function echoColor() {
	case $1 in
		# red
	"red")
		echo -e "\033[31m${printN}$2 \033[0m"
		;;
		# sky blue
	"skyBlue")
		echo -e "\033[1;36m${printN}$2 \033[0m"
		;;
		# green
	"green")
		echo -e "\033[32m${printN}$2 \033[0m"
		;;
		# White
	"white")
		echo -e "\033[37m${printN}$2 \033[0m"
		;;
	"magenta")
		echo -e "\033[31m${printN}$2 \033[0m"
		;;
		# yellow
	"yellow")
		echo -e "\033[33m${printN}$2 \033[0m"
		;;
        # Purple
    "purple")
        echo -e "\033[1;;35m${printN}$2 \033[0m"
        ;;
        #
    "yellowBlack")
        # Yellow lettering on black background
        echo -e "\033[1;33;40m${printN}$2 \033[0m"
        ;;
	"greenWhite")
		# white text on green background
		echo -e "\033[42;37m${printN}$2 \033[0m"
		;;
	esac
}

function checkSystemForUpdate() {
	if [[ -n $(find /etc -name "redhat-release") ]] || grep </proc/version -q -i "centos"; then
		mkdir -p /etc/yum.repos.d

		if [[ -f "/etc/centos-release" ]]; then
			centosVersion=$(rpm -q centos-release | awk -F "[-]" '{print $3}' | awk -F "[.]" '{print $1}')

			if [[ -z "${centosVersion}" ]] && grep </etc/centos-release -q -i "release 8"; then
				centosVersion=8
			fi
		fi
		release="centos"
		installType='yum -y -q install'
		removeType='yum -y -q remove'
		upgrade="yum update -y  --skip-broken"

	elif grep </etc/issue -q -i "debian" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "debian" && [[ -f "/proc/version" ]]; then
		release="debian"
		installType='apt -y -q install'
		upgrade="apt update"
		updateReleaseInfoChange='apt-get --allow-releaseinfo-change update'
		removeType='apt -y -q autoremove'

	elif grep </etc/issue -q -i "ubuntu" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "ubuntu" && [[ -f "/proc/version" ]]; then
		release="ubuntu"
		installType='apt -y -q install'
		upgrade="apt update"
		updateReleaseInfoChange='apt-get --allow-releaseinfo-change update'
		removeType='apt -y -q autoremove'
		if grep </etc/issue -q -i "16."; then
			release=
		fi
	fi

	if [[ -z ${release} ]]; then
		echoColor red "\nThis script does not support this system, please feedback the log below to the developer\n"
		echoColor yellow "$(cat /etc/issue)"
		echoColor yellow "$(cat /proc/version)"
		exit 0
	fi
    echoColor purple "\nUpdate.wait..."
    ${upgrade}
	if ! [ -x "$(command -v wget)" ]; then
		echoColor green "*wget"
		${installType} "wget"
	fi
	if ! [ -x "$(command -v curl)" ]; then
		echoColor green "*curl"
		${installType} "curl"
	fi
	if ! [ -x "$(command -v lsof)" ]; then
		echoColor green "*lsof"
		${installType} "lsof"
	fi
	if ! [ -x "$(command -v dig)" ]; then
		echoColor green "*dnsutils"
		if [[ ${release} == "centos" ]]; then
			${installType} "bind-utils"
		else
			${installType} "dnsutils"
		fi
	fi
    echoColor purple "\nDone."
    
}

function uninstall(){
	rm -r /usr/bin/hihy
    bash <(curl -fsSL https://git.io/rmhysteria.sh)
}

function reinstall(){
    bash <(curl -fsSL https://git.io/rehysteria.sh)
}

function printMsg(){
	msg=`cat /etc/hihy/conf/hihy.conf | grep "remarks"`
	remarks=${msg#*:}
	cp -P /etc/hihy/result/hihyClient.json ./Hys-${remarks}\(v2rayN\).json
	cp -P /etc/hihy/result/metaHys.yaml ./Hys-${remarks}\(clashMeta\).yaml
	echoColor yellow "--------------------------------------------"
	echo ""
	echo -e "\033[1;;35m1* [\033[0m\033[31mv2rayN/Matsuri/nekobox/nekoray\033[0m\033[1;;35m] Use hysteria core to run directly: \033[0m"
	echoColor green "The client configuration file is output to: `pwd`/Hys-${remarks}(v2rayN).json (directly download the generated configuration file [recommended] / copy and paste the configuration below to local)"
	echoColor green "Tips: The client only enables http (10809), socks5 (10808) proxy by default! For other methods, please refer to the hysteria documentation to modify the client config.json"
	echoColor skyBlue "↓************************************↓↓↓copy↓↓↓**** *****************************↓"
	cat ./Hys-${remarks}\(v2rayN\).json
	echoColor skyBlue "↑***********************************↑↑↑copy↑↑↑*******************************↑\n"
	url=`cat /etc/hihy/result/url.txt`
	echo -e  "\033[1;;35m2* [\033[0m\033[31mShadowrocket/Matsuri/nekobox/Passwall\033[0m\033[1;;35m] 一键链接: \033[0m"
	echoColor green ${url}
	echo -e "\n"
	echo -e "\033[1;;35m3* [\033[0m\033[31mClash.Meta\033[0m\033[1;;35m] The configuration file is already in `pwd`/Hys-${remarks}( clashMeta).yaml output, please download to the client to use (beta)\033[0m"	echoColor yellow "--------------------------------------------"
}

function hihy(){
	if [ ! -f "/usr/bin/hihy" ]; then
  		wget -q -O /usr/bin/hihy --no-check-certificate https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/server/install.sh
		chmod +x /usr/bin/hihy
	fi	
}

function changeIp64(){
    if [ ! -f "/etc/hihy/conf/hihyServer.json" ]; then
  		echoColor red "未正常安装hihy!"
        exit
	fi 
	now=`cat /etc/hihy/conf/hihyServer.json | grep "resolve_preference"`
    case ${now} in 
		*"64"*)
			echoColor purple "current ipv6 priority"
            echoColor yellow "\n->Set ipv4 priority higher than ipv6? (Y/N, default N)"
            read input
            if [ -z "${input}" ];then
                echoColor green "Ignore."
                exit
            else
                sed -i 's/"resolve_preference": "64"/"resolve_preference": "46"/g' /etc/hihy/conf/hihyServer.json
                systemctl restart hihy
                echoColor green "Done.Ipv4 first now."
            fi
            
		;;
		*"46"*)
			echoColor purple "current ipv4 priority"
            echoColor yellow "\n->Set ipv6 priority higher than ipv4? (Y/N, default N)"    
			read input
            if [ -z "${input}" ];then
                echoColor green "Ignore."
                exit
            else
                sed -i 's/"resolve_preference": "46",/"resolve_preference": "64",/g' /etc/hihy/conf/hihyServer.json
                systemctl restart hihy
                echoColor green "Done.Ipv6 first now."
            fi
        ;;
	esac
}

function getPortBindMsg(){
        # $1 type UDP or TCP
        # $2 port
		if [ $1 == "UDP" ]; then
        	msg=`lsof -i ${1}:${2}`
		else
			msg=`lsof -i ${1}:${2} | grep LISTEN`
		fi
        if [ "${msg}" == "" ];then
                return
        else	
				command=`echo ${msg} | awk '{print $1}'`
  				pid=`echo ${msg} | awk '{print $2}'`
  				name=`echo ${msg} | awk '{print $9}'`
          		echoColor purple "Port: ${1}/${2} has been occupied by ${command}(${name}), the process pid is: ${pid}."
				echoColor green "Do you automatically close the port occupation? (y/N)"
				read bindP
				if [ -z "${bindP}" ];then
					echoColor red "Exit the installation because the port is occupied. Please manually close or replace the port..."
					if [ "${1}" == "TCP" ] && [ "${2}" == "80" ];then
						echoColor "If the ${1}/${2} ports cannot be closed according to requirements, please use other certificate acquisition methods"
					fi
					exit
				elif [ "${bindP}" == "y" ] ||  [ "${bindP}" == "Y" ];then
					kill -9 ${pid}
					echoColor purple "正在解绑..."
					sleep 3
					if [ $1 == "TCP" ]; then
						msg=`lsof -i ${1}:${2} | grep LISTEN`
					else
						msg=`lsof -i ${1}:${2}`
					fi
        			if [ "${msg}" != "" ];then
						echoColor red "The port occupancy shutdown failed. The process restarts after the process is forcibly killed. Please check whether there is a daemon process..."
						exit
					else
						echoColor green "Port unbind successfully..."
					fi
				else
					echoColor red "Exit the installation because the port is occupied. Please manually close or replace the port..."
					if [ "${1}" == "TCP" ] && [ "${2}" == "80" ];then
						echoColor "If the ${1}/${2} ports cannot be closed according to requirements, please use other certificate acquisition methods"
					fi
					exit
				fi
        fi
}

function setHysteriaConfig(){
	mkdir -p /etc/hihy/bin /etc/hihy/conf /etc/hihy/cert  /etc/hihy/result /etc/hihy/acl
	echoColor yellowBlack "Start configuration:"
	echo -e "\033[32mPlease select the certificate application method:\n\n\033[0m\033[33m\033[01m1, use ACME to apply (recommended, need to open tcp 80/443)\n2, use local certificate file\n3 、Self-signed certificate\033[0m\033[32m\n\nEnter serial number:\033[0m"
    read certNum
	useAcme=false
	useLocalCert=false
	if [ -z "${certNum}" ] || [ "${certNum}" == "3" ];then
		echo -e "\nNote: The self-signed certificate has been randomly blocked in recent times without obfs"
		echoColor red "If you must use a self-signed certificate, please choose to use obfs obfuscated verification in the configuration below to ensure security"
		echoColor green "Please enter the domain name of the self-signed certificate (default: wechat.com):"
		read domain
		if [ -z "${domain}" ];then
			domain="wechat.com"
		fi
		echo -e "->Self-signed certificate domain name is:"`echoColor red ${domain}`"\n"
		ip=`curl -4 -s -m 8 ip.sb`
		if [ -z "${ip}" ];then
			ip=`curl -s -m 8 ip.sb`
		fi
		echoColor green "Judge whether the address used by the client connection is correct? Public network ip:"`echoColor red ${ip}`"\n"
		while true
		do	
			echo -e "\033[32m please choose:\n\n\033[0m\033[33m\033[01m1, correct (default)\n2, incorrect, manually input ip\033[0m\033[32m\n\n Enter serial number:\033[0m"
			read ipNum
			if [ -z "${ipNum}" ] || [ "${ipNum}" == "1" ];then
				break
			elif [ "${ipNum}" == "2" ];then
				echoColor green "Please enter the correct public network ip (ipv6 address does not need to add []):"
				read ip
				if [ -z "${ip}" ];then
					echoColor red "Input errors, please re-enter..."
					continue
				fi
				break
			else
				echoColor red "\n->Input error, please re-enter:"
			fi
		done		
		cert="/etc/hihy/cert/${domain}.crt"
		key="/etc/hihy/cert/${domain}.key"
		useAcme=false
		echoColor purple "\n\n->You have chosen self-signed ${domain} certificate encryption. Public network ip:"`echoColor red ${ip}`"\n"
		echo -e "\n"
    elif [ "${certNum}" == "2" ];then
		echoColor green "Please enter the certificate cert file path (requires fullchain cert, provide a complete certificate chain):"
		read cert
		while :
		do
			if [ ! -f "${cert}" ];then
				echoColor red "\n\n->Path does not exist, please re-enter!"
				echoColor green "Please enter the certificate file path:"
				read  cert
			else
				break
			fi
		done
		echo -e "\n\n->cert file path: "`echoColor red ${cert}`"\n"
		echoColor green "Please enter the certificate key file path:"
		read key
		while :
		do
			if [ ! -f "${key}" ];then
				echoColor red "\n\n->Path does not exist, please re-enter!"
				echoColor green "Please enter the certificate key file path:"
				read  key
			else
				break
			fi
		done
		echo -e "\n\n->key file path: "`echoColor red ${key}`"\n"
		echoColor green "Please enter the domain name of the selected certificate:"
		read domain
		while :
		do
			if [ -z "${domain}" ];then
				echoColor red "\n\n->This option cannot be empty, please re-enter!"
				echoColor green "Please enter the domain name of the selected certificate:"
				read  domain
			else
				break
			fi
		done
		useAcme=false
		useLocalCert=true
		echoColor purple "\n\n->You have selected local certificate encryption. Domain name: "`echoColor red ${domain}`"\n"
    else 
    	echoColor green "Please enter the domain name (it needs to be correctly resolved to the local machine, and the CDN is turned off):"
		read domain
		while :
		do
			if [ -z "${domain}" ];then
				echoColor red "\n\n->This option cannot be empty, please re-enter!"
				echoColor green "Please enter the domain name (it needs to be correctly resolved to the local machine, and the CDN is turned off):"
				read  domain
			else
				break
			fi
		done
		while :
		do	
			echoColor purple "\n->Detect ${domain}, DNS resolution..."
			ip_resolv=`dig +short ${domain} A`
			if [ -z "${ip_resolv}" ];then
				ip_resolv=`dig +short ${domain} AAAA`
			fi
			if [ -z "${ip_resolv}" ];then
				echoColor red "\n\n->The domain name resolution failed, no dns record (A/AAAA) was obtained, please check whether the domain name is correctly resolved to this machine!"
				echoColor green "Please enter the domain name (it needs to be correctly resolved to the local machine, and the CDN is turned off):"
				read  domain
				continue
			fi
			remoteip=`echo ${ip_resolv} | awk -F " " '{print $1}'`
			v6str=":" #Is ipv6?
			result=$(echo ${remoteip} | grep ${v6str})
			if [ "${result}" != "" ];then
				localip=`curl -6 -s -m 8 ip.sb`
			else
				localip=`curl -4 -s -m 8 ip.sb`
			fi
			if [ -z "${localip}" ];then
				localip=`curl -s -m 8 ip.sb` #If the above ip.sb fails, the last test
				if [ -z "${localip}" ];then
					echoColor red "\n\n->failed to get local ip, please check network connection!curl -s -m 8 ip.sb"
					exit 1
				fi
			fi
			if [ "${localip}" != "${remoteip}" ];then
				echo -e " \n\n->local ip: "`echoColor red ${localip}`" \n\n->domain name ip: "`echoColor red ${remoteip}`"\n"
				echoColor green "The detection may fail when multiple ip or dns are not in effect. If you are sure that the local machine is resolved correctly, do you want to specify the local ip yourself? [y/N]:"
				read isLocalip
				if [ "${isLocalip}" == "y" ];then
					echoColor green "Please enter the local ip:"
					read localip
					while :
					do
						if [ -z "${localip}" ];then
							echoColor red "\n\n->This option cannot be empty, please re-enter!"
							echoColor green "Please enter the local ip:"
							read  localip
						else
							break
						fi
					done
				fi
				if [ "${localip}" != "${remoteip}" ];then
					echoColor red "\n\n->The ip resolved by the domain name is inconsistent with the local ip, please re-enter!"
					echoColor green "Please enter the domain name (it needs to be correctly resolved to the local machine, and the CDN is turned off):"
					read  domain
					continue
				else
					break
				fi
			else
				break
			fi
		done
		useAcme=true
		echoColor purple "\n\n->The parsing is correct, use hysteria's built-in ACME to apply for a certificate. Domain name: "`echoColor red ${domain}`"\n"
    fi

    echo -e "\033[32m Select protocol type:\n\n\033[0m\033[33m\033[01m1, udp (QUIC, can start port jumping)\n2, faketcp\n3, wechat-video (default )\033[0m\033[32m\n\nEnter serial number:\033[0m"
    read protocol
	ut=
    if [ -z "${protocol}" ] || [ $protocol == "3" ];then
		protocol="wechat-video"
		ut="udp"
    elif [ $protocol == "2" ];then
		protocol="faketcp"
		ut="tcp"
    else 
    	protocol="udp"
		ut="udp"
    fi
    echo -e "\n->传输协议:"`echoColor red ${protocol}`"\n"

	while :
	do
		echoColor green "Please enter the port you want to open. This port is the server port. 10000-65535 is recommended. (Random by default)"
		read  port
		if [ -z "${port}" ];then
			port=$(($(od -An -N2 -i /dev/random) % (65534 - 10001) + 10001))
			echo -e "\n->Use random port:"`echoColor red ${ut}/${port}`"\n"
		else
			echo -e "\n->The port you entered:"`echoColor red ${ut}/${port}`"\n"
		fi
		if [ "${port}" -gt 65535 ];then
			echoColor red "The port range is wrong, please re-enter!"
			continue
		fi
		if [ "${ut}" != "udp" ];then
			pIDa=`lsof -i ${ut}:${port} | grep "LISTEN" | grep -v "PID" | awk '{print $2}'`
		else
			pIDa=`lsof -i ${ut}:${port} | grep -v "PID" | awk '{print $2}'`
		fi
		if [ "$pIDa" != "" ];
		then
			echoColor red "\n->Port ${port} is occupied, PID: ${pIDa}! Please re-enter or run kill -9 ${pIDa} and reinstall!"
		else
			break
		fi
		
	done
	clientPort="${port}"
	if [ "${protocol}" == "udp" ];then
		echoColor green "\n->It is detected that you have selected the udp protocol, you can use the [Port Hopping/Multiport] (Port Hopping) function, it is recommended to use"
		echo -e "Tip: The long-term single-port UDP connection is easy to be blocked by the operator/QoS/cut off, enabling this function can effectively avoid this problem."
		echo -e "For more details, please refer to: https://github.com/emptysuns/Hi_Hysteria/blob/main/md/portHopping.md\n"
		echo -e "\033[32m choose whether to enable:\n\n\033[0m\033[33m\033[01m1, enable (default)\n2, skip\033[0m\033[32m\n\n Enter serial number:\033[0m"
		read portHoppingStatus
		if [ -z "${portHoppingStatus}" ] || [ $portHoppingStatus == "1" ];then
			portHoppingStatus="true"
			echoColor purple "\n->You choose to enable Port Hopping/Multiple Ports (Port Hopping)"
			echo -e "The port hopping/multi-port (Port Hopping) function needs to occupy multiple ports, please ensure that these ports are not listening to other services\nTip: The number of ports should not be too many, about 1000 are recommended, the range is 1-65535, it is recommended to choose Contiguous port range.\n"		
			while :
			do
				echoColor green "Please enter the starting port (default 47000):"
				read  portHoppingStart
				if [ -z "${portHoppingStart}" ];then
					portHoppingStart=47000
				fi
				if [ $portHoppingStart -gt 65535 ];then
					echoColor red "\n->The port range is wrong, please re-enter!"
					continue
				fi
				echo -e "\n->Start port:"`echoColor red ${portHoppingStart}`"\n"
				echoColor green "Please enter the end port (default 48000):"
				read  portHoppingEnd
				if [ -z "${portHoppingEnd}" ];then
					portHoppingEnd=48000
				fi
				if [ $portHoppingEnd -gt 65535 ];then
					echoColor red "\n->The port range is wrong, please re-enter!"
					continue
				fi
				echo -e "\n->end port:"`echoColor red ${portHoppingEnd}`"\n"
				if [ $portHoppingStart -ge $portHoppingEnd ];then
					echoColor red "\n->The start port must be smaller than the end port, please re-enter!"
				else
					break
				fi
			done
			clientPort="${port},${portHoppingStart}-${portHoppingEnd}"
			echo -e "\n->The port hopping/multi-port (Port Hopping) parameter you selected is: "`echoColor red ${portHoppingStart}:${portHoppingEnd}`"\n"
		else
			portHoppingStatus="false"
			echoColor red "\n->You choose to skip Port Hopping/Multiport (Port Hopping) function"
		fi
	fi

    echoColor green "请输入您到此服务器的平均延迟,关系到转发速度(默认200,单位:ms):"
    read  delay
    if [ -z "${delay}" ];then
		delay=200
    fi
	echo -e "\n->Delay:`echoColor red ${delay}`ms\n"
    echo -e "\nExpected speed, this is the peak speed of the client, and the server is not limited by default." `echoColor red Tips: The script will automatically *1.10 for redundancy, if your expectation is too low or too high, it will affect the forwarding efficiency, Please fill in truthfully!`
     echoColor green "Please enter the downlink speed expected by the client: (default 50, unit: mbps):"
    read  download
    if [ -z "${download}" ];then
        download=50
    fi
	echo -e "\n->client download speed: "`echoColor red ${download}`"mbps\n"
    echo -e "\033[32m Please enter the expected uplink speed of the client (default 10, unit: mbps):\033[0m"
    read  upload
    if [ -z "${upload}" ];then
        upload=10
    fi
	echo -e "\n->client uplink speed: "`echoColor red ${upload}`"mbps\n"
echoColor green "Please enter the authentication password (randomly generated by default, a strong password of more than 20 characters is recommended):"
	read auth_secret
	if [ -z "${auth_secret}" ];then
		auth_secret=`tr -cd '0-9A-Za-z' < /dev/urandom | fold -w50 | head -n1`
	fi
	echo -e "\n->认证口令:"`echoColor red ${auth_secret}`"\n"
	auth_str=""
	obfs_str=""
	echo -e "Tips: If obfs obfuscated encryption is used, the anti-blocking ability is stronger, and it can be recognized as unknown udp traffic, but it will increase the CPU load and cause the peak speed to drop. If you are pursuing performance and are not targeted for blocking, it is recommended not to use it"
	echo -e "\033[32m select authentication method:\n\n\033[0m\033[33m\033[01m1, auth_str (default)\n2, obfs\033[0m\033[32m\n\nInput Serial number:\033[0m"
	read auth_num
	if [ -z "${auth_num}" ] || [ ${auth_num} == "1" ];then
		auth_type="auth_str"
		auth_str=${auth_secret}
		server_auth_conf=$(cat <<- EOF
"auth": {
"mode": "password",
"config": {
"password": "${auth_str}"
}
},
EOF
)
	else
		auth_type="obfs"
		auth_str=""
		obfs_str=${auth_secret}
		server_auth_conf=$(cat <<- EOF
"obfs": "${obfs_str}",
EOF
)
	fi
	echo -e "\n->The authentication method you selected is: "`echoColor red ${auth_type}`"\n"
	echoColor green "Please enter the client name for remarks (by default, the domain name/IP is used to distinguish, for example, if you enter test, the name is Hys-test):"
	read remarks
    echoColor green "\nConfiguration entry complete!\n"
    echoColor yellowBlack "Execute configuration..."
    download=$(($download + $download / 10))
    upload=$(($upload + $upload / 10))
    r_client=$(($delay * 2 * $download / 1000 * 1024 * 1024))
    r_conn=$(($r_client / 4))
    if echo "${useAcme}" | grep -q "false";then
		if echo "${useLocalCert}" | grep -q "false";then
			v6str=":" #Is ipv6?
			result=$(echo ${ip} | grep ${v6str})
			if [ "${result}" != "" ];then
				ip="[${ip}]" 
			fi
			u_host=${ip}
			u_domain=${domain}
			if [ -z "${remarks}" ];then
				remarks="${ip}"
			fi
			sec="1"
			mail="admin@qq.com"
			days=36500
			echoColor purple "SIGN...\n"
			openssl genrsa -out /etc/hihy/cert/${domain}.ca.key 2048
			openssl req -new -x509 -days ${days} -key /etc/hihy/cert/${domain}.ca.key -subj "/C=CN/ST=GuangDong/L=ShenZhen/O=PonyMa/OU=Tecent/emailAddress=${mail}/CN=Tencent Root CA" -out /etc/hihy/cert/${domain}.ca.crt
			openssl req -newkey rsa:2048 -nodes -keyout /etc/hihy/cert/${domain}.key -subj "/C=CN/ST=GuangDong/L=ShenZhen/O=PonyMa/OU=Tecent/emailAddress=${mail}/CN=Tencent Root CA" -out /etc/hihy/cert/${domain}.csr
			openssl x509 -req -extfile <(printf "subjectAltName=DNS:${domain},DNS:${domain}") -days ${days} -in /etc/hihy/cert/${domain}.csr -CA /etc/hihy/cert/${domain}.ca.crt -CAkey /etc/hihy/cert/${domain}.ca.key -CAcreateserial -out /etc/hihy/cert/${domain}.crt
			rm /etc/hihy/cert/${domain}.ca.key /etc/hihy/cert/${domain}.ca.srl /etc/hihy/cert/${domain}.csr
			mv /etc/hihy/cert/${domain}.ca.crt /etc/hihy/result
			echoColor purple "SUCCESS.\n"
			cat <<EOF > /etc/hihy/result/hihyClient.json
{
"server": "${ip}:${clientPort}",
"protocol": "${protocol}",
"up_mbps": ${upload},
"down_mbps": ${download},
"http": {
"listen": "127.0.0.1:10809",
"timeout" : 300,
"disable_udp": false
},
"socks5": {
"listen": "127.0.0.1:10808",
"timeout": 300,
"disable_udp": false
},
"obfs": "${obfs_str}",
"auth_str": "${auth_str}",
"alpn": "h3",
"acl": "acl/routes.acl",
"mmdb": "acl/Country.mmdb",
"server_name": "${domain}",
"insecure": true,
"recv_window_conn": ${r_conn},
"recv_window": ${r_client},
"disable_mtu_discovery": true,
"resolver": "https://223.5.5.5/dns-query",
"retry": 3,
"retry_interval": 3,
"quit_on_disconnect": false,
"handshake_timeout": 15,
"idle_timeout": 30,
"fast_open": true,
"hop_interval": 120
}
EOF
		else
			u_host=${domain}
			u_domain=${domain}
			if [ -z "${remarks}" ];then
				remarks="${domain}"
			fi
			sec="0"
			cat <<EOF > /etc/hihy/result/hihyClient.json
{
"server": "${domain}:${clientPort}",
"protocol": "${protocol}",
"up_mbps": ${upload},
"down_mbps": ${download},
"http": {
"listen": "127.0.0.1:10809",
"timeout" : 300,
"disable_udp": false
},
"socks5": {
"listen": "127.0.0.1:10808",
"timeout": 300,
"disable_udp": false
},
"obfs": "${obfs_str}",
"alpn": "h3",
"acl": "acl/routes.acl",
"mmdb": "acl/Country.mmdb",
"auth_str": "${auth_str}",
"server_name": "${domain}",
"insecure": false,
"recv_window_conn": ${r_conn},
"recv_window": ${r_client},
"disable_mtu_discovery": true,
"resolver": "https://223.5.5.5/dns-query",
"retry": 3,
"retry_interval": 3,
"quit_on_disconnect": false,
"handshake_timeout": 15,
"idle_timeout": 30,
"fast_open": true,
"hop_interval": 120
}
EOF
		fi		
		cat <<EOF > /etc/hihy/conf/hihyServer.json
{
"listen": ":${port}",
"protocol": "${protocol}",
"disable_udp": false,
"cert": "${cert}",
"key": "${key}",
${server_auth_conf}
"alpn": "h3",
"acl": "/etc/hihy/acl/hihyServer.acl",
"recv_window_conn": ${r_conn},
"recv_window_client": ${r_client},
"max_conn_client": 4096,
"resolve_preference": "46",
"disable_mtu_discovery": true
}
EOF

    else
		u_host=${domain}
		u_domain=${domain}
		sec="0"
		if [ -z "${remarks}" ];then
			remarks="${domain}"
		fi
		getPortBindMsg TCP 80
		allowPort tcp 80
		cat <<EOF > /etc/hihy/conf/hihyServer.json
{
"listen": ":${port}",
"protocol": "${protocol}",
"acme": {
"domains": [
"${domain}"
],
"email": "pekora@${domain}"
},
"disable_udp": false,
${server_auth_conf}
"alpn": "h3",
"acl": "/etc/hihy/acl/hihyServer.acl",
"recv_window_conn": ${r_conn},
"recv_window_client": ${r_client},
"max_conn_client": 4096,
"resolve_preference": "46",
"disable_mtu_discovery": true
}
EOF

		cat <<EOF > /etc/hihy/result/hihyClient.json
{
"server": "${domain}:${clientPort}",
"protocol": "${protocol}",
"up_mbps": ${upload},
"down_mbps": ${download},
"http": {
"listen": "127.0.0.1:10809",
"timeout" : 300,
"disable_udp": false
},
"socks5": {
"listen": "127.0.0.1:10808",
"timeout": 300,
"disable_udp": false
},
"obfs": "${obfs_str}",
"alpn": "h3",
"acl": "acl/routes.acl",
"mmdb": "acl/Country.mmdb",
"auth_str": "${auth_str}",
"server_name": "${domain}",
"insecure": false,
"recv_window_conn": ${r_conn},
"recv_window": ${r_client},
"disable_mtu_discovery": true,
"resolver": "https://223.5.5.5/dns-query",
"retry": 3,
"retry_interval": 3,
"quit_on_disconnect": false,
"handshake_timeout": 15,
"idle_timeout": 30,
"fast_open": true,
"hop_interval": 120
}
EOF
    fi
	sysctl -w net.core.rmem_max=80000000
	if echo "${portHoppingStatus}" | grep -q "true";then
		sysctl -w net.ipv4.ip_forward=1
		sysctl -w net.ipv6.conf.all.forwarding=1
	fi
    sysctl -p
	echo -e "\033[1;;35m\nTest config...\n\033[0m"
	echo "block all udp/443" > /etc/hihy/acl/hihyServer.acl
	/etc/hihy/bin/appS -c /etc/hihy/conf/hihyServer.json server > /tmp/hihy_debug.info 2>&1 &
	sleep 15
	msg=`cat /tmp/hihy_debug.info`
	case ${msg} in 
		*"Failed to get a certificate with ACME"*)
			echoColor red "Domain name: ${u_host}, failed to apply for a certificate! Please check whether the panel firewall provided by the server is enabled (TCP: 80,443)\nWhether the domain name is correctly resolved to this ip (do not open CDN!)\nIf the above two conditions cannot be met point, please reinstall using a self-signed certificate."
			rm /etc/hihy/conf/hihyServer.json
			rm /etc/hihy/result/hihyClient.json
			delHihyFirewallPort
			if echo ${portHoppingStatus} | grep -q "true";then
				delHihyFirewallPort ${portHoppingStart} ${portHoppingEnd} ${port}
			fi
			rm /tmp/hihy_debug.info
			exit
			;;
		*"bind: address already in use"*)
			rm /etc/hihy/conf/hihyServer.json
			rm /etc/hihy/result/hihyClient.json
			delHihyFirewallPort
			if echo ${portHoppingStatus} | grep -q "true";then
				delHihyFirewallPort ${portHoppingStart} ${portHoppingEnd} ${port}
			fi
			echoColor red "The port is occupied, please change the port!"
			rm /tmp/hihy_debug.info
			exit
			;;
		*"Server up and running"*)
			echoColor green "Test success!"
			if [ "${portHoppingStatus}" == "true" ];then
				addPortHoppingNat ${portHoppingStart} ${portHoppingEnd} ${port}
			fi
			allowPort ${ut} ${port}
			echoColor purple "Generating config..."
			if [ "${ut}" == "tcp" ];then
				pIDa=`lsof -i ${ut}:${port} | grep LISTEN | grep -v "PID" | awk '{print $2}'`
			else
				pIDa=`lsof -i ${ut}:${port} | grep -v "PID" | awk '{print $2}'`
			fi
			kill -9 ${pIDa} > /dev/null 2>&1
			rm /tmp/hihy_debug.info
			;;
		*) 	
			if [ "${ut}" == "tcp" ];then
				pIDa=`lsof -i ${ut}:${port} | grep LISTEN | grep -v "PID" | awk '{print $2}'`
			else
				pIDa=`lsof -i ${ut}:${port} | grep -v "PID" | awk '{print $2}'`
			fi
			kill -9 ${pIDa} > /dev/null 2>&1
			rm /etc/hihy/result/hihyClient.json
			delHihyFirewallPort
			if echo ${portHoppingStatus} | grep -q "true";then
				delHihyFirewallPort ${portHoppingStart} ${portHoppingEnd} ${port}
			fi
			echoColor red "Unknown error: Please check the error message below and submit an issue to github"
			cat /tmp/hihy_debug.info
			rm /tmp/hihy_debug.info
			exit
			;;
	esac
	echo "remarks:${remarks}" >> /etc/hihy/conf/hihy.conf
	echo "serverAddress:${u_host}" >> /etc/hihy/conf/hihy.conf
	echo "serverPort:${port}" >> /etc/hihy/conf/hihy.conf
	echo "portHoppingStatus:${portHoppingStatus}" >> /etc/hihy/conf/hihy.conf
	echo "portHoppingStart:${portHoppingStart}" >> /etc/hihy/conf/hihy.conf
	echo "portHoppingEnd:${portHoppingEnd}" >> /etc/hihy/conf/hihy.conf
	if [ $sec = "1" ];then
		skip_cert_verify="true"
	else
		skip_cert_verify="false"
	fi
	if echo ${portHoppingStatus} | grep -q "true";then
		generateMetaYaml "Hys-${remarks}" "${u_host}" "${port}" "${auth_str}" "${protocol}" "${upload}" "${download}" "${u_domain}" "${skip_cert_verify}" "${r_conn}" "${r_client}" "${obfs_str}" "${portHoppingStart}" "${portHoppingEnd}"
		url="hysteria://${u_host}:${port}?mport=${portHoppingStart}-${portHoppingEnd}&protocol=${protocol}&auth=${auth_str}&obfsParam=${obfs_str}&peer=${u_domain}&insecure=${sec}&upmbps=${upload}&downmbps=${download}&alpn=h3#Hys-${remarks}"
	else
		generateMetaYaml "Hys-${remarks}" "${u_host}" "${port}" "${auth_str}" "${protocol}" "${upload}" "${download}" "${u_domain}" "${skip_cert_verify}" "${r_conn}" "${r_client}" "${obfs_str}"
		url="hysteria://${u_host}:${port}?protocol=${protocol}&auth=${auth_str}&obfsParam=${obfs_str}&peer=${u_domain}&insecure=${sec}&upmbps=${upload}&downmbps=${download}&alpn=h3#Hys-${remarks}"
	fi
	echo ${url} > /etc/hihy/result/url.txt
	echoColor greenWhite "The installation is successful, please check the configuration details below"
}

function downloadHysteriaCore(){
	version=`curl --head -s https://github.com/apernet/hysteria/releases/latest | grep -i location | grep -o 'tag/[^[:space:]]*' | sed 's/tag\///;s/ //g'`
	#Compatible with the v1 version update after the release of v2 (temporary, the next version will be removed)
	version="v1.3.5"
	echo -e "The Latest hysteria version:"`echoColor red "${version}"`"\nDownload..."
	if [ -z ${version} ];then
		echoColor red "[Network error]: Failed to get the latest version of hysteria in Github!"
		exit
	fi 
    get_arch=`arch`
    if [ $get_arch = "x86_64" ];then
        wget -q -O /etc/hihy/bin/appS --no-check-certificate https://github.com/apernet/hysteria/releases/download/${version}/hysteria-linux-amd64
    elif [ $get_arch = "aarch64" ];then
        wget -q -O /etc/hihy/bin/appS --no-check-certificate https://github.com/apernet/hysteria/releases/download/${version}/hysteria-linux-arm64
    elif [ $get_arch = "mips64" ];then
        wget -q -O /etc/hihy/bin/appS --no-check-certificate https://github.com/apernet/hysteria/releases/download/${version}/hysteria-linux-mipsle
	elif [ $get_arch = "s390x" ];then
		wget -q -O /etc/hihy/bin/appS --no-check-certificate https://github.com/apernet/hysteria/releases/download/${version}/hysteria-linux-s390x
	elif [ $get_arch = "i686" ];then
		wget -q -O /etc/hihy/bin/appS --no-check-certificate https://github.com/apernet/hysteria/releases/download/${version}/hysteria-linux-386
    else
        echoColor yellowBlack "Error[OS Message]:${get_arch}\nPlease open a issue to https://github.com/emptysuns/Hi_Hysteria/issues !"
        exit
    fi
	if [ -f "/etc/hihy/bin/appS" ]; then
		chmod 755 /etc/hihy/bin/appS
		echoColor purple "\nDownload completed."
	else
		echoColor red "Network Error: Can't connect to Github!"
	fi
}

function updateHysteriaCore(){
	if [ -f "/etc/hihy/bin/appS" ]; then
		localV=`/etc/hihy/bin/appS -v | cut -d " " -f 3`
		remoteV=`curl --head -s https://github.com/apernet/hysteria/releases/latest | grep -i location | grep -o 'tag/[^[:space:]]*' | sed 's/tag\///;s/ //g'`
		#Compatible with the v1 version update after the release of v2 (temporary, the next version will be removed)
		remoteV="v1.3.5"
		if [ -z $remoteV ];then
			echoColor red "Network Error: Can't connect to Github!"
			exit
		fi
		echo -e "Local core version:"`echoColor red "${localV}"`
		echo -e "Remote core version:"`echoColor red "${remoteV}"`
		if [ "${localV}" = "${remoteV}" ];then
			echoColor green "Already the latest version.Ignore."
		else
			status=`systemctl is-active hihy`
			if [ "${status}" = "active" ];then #如果是正常运行情况下将先停止守护进程再自动更新后重启，否则只负责更新
				systemctl stop hihy
				downloadHysteriaCore
				systemctl start hihy
			else
				downloadHysteriaCore
			fi
			echoColor green "Hysteria Core update done."
		fi
	else
		echoColor red "hysteria core not found."
		exit
	fi
}



function changeServerConfig(){
	if [ ! -f "/etc/systemd/system/hihy.service" ]; then
		echoColor red "Please install hysteria first, and then modify the configuration..."
		exit
	fi
	echoColor red "Stop hihy service..."
	systemctl stop hihy
	echoColor red "Delete old config..."
	if [ -f "/etc/hihy/conf/hihy.conf" ]; then
		portHoppingStatus=`cat /etc/hihy/conf/hihy.conf | grep "portHopping" | awk -F ":" '{print $2}'`
		portHoppingStart=`cat /etc/hihy/conf/hihy.conf | grep "portHoppingStart" | awk -F ":" '{print $2}'`
		portHoppingEnd=`cat /etc/hihy/conf/hihy.conf | grep "portHoppingEnd" | awk -F ":" '{print $2}'`
		serverPort=`cat /etc/hihy/conf/hihy.conf | grep "serverPort" | awk -F ":" '{print $2}'`
		msg=`cat /etc/hihy/conf/hihy.conf | grep "remarks"`
		remarks=${msg#*:}
		rm -r /etc/hihy/conf/hihy.conf
		if [ -f "./Hys-${remarks}\(v2rayN\).json" ];then
			rm ./Hys-${remarks}\(v2rayN\).json
		fi
		if [ -f "./Hys-${remarks}\(clashMeta\).yaml" ];then
			rm ./Hys-${remarks}\(clashMeta\).yaml
		fi
		if echo "${portHoppingStatus}" | grep -q "true";then
			delPortHoppingNat ${portHoppingStart} ${portHoppingEnd} ${serverPort}
		fi
	fi
	delHihyFirewallPort
	updateHysteriaCore
	setHysteriaConfig
	systemctl start hihy
	printMsg
	echoColor yellowBlack "Reconfiguration complete."
	
}

function hihyUpdate(){
	localV=${hihyV}
	remoteV=`curl -fsSL https://git.io/hysteria.sh | sed  -n 2p | cut -d '"' -f 2`
	if [ -z $remoteV ];then
		echoColor red "Network Error: Can't connect to Github!"
		exit
	fi
	if [ "${localV}" = "${remoteV}" ];then
		echoColor green "Already the latest version.Ignore."
	else
		rm -r /usr/bin/hihy
		wget -q -O /usr/bin/hihy --no-check-certificate https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/server/install.sh 2>/dev/null
		chmod +x /usr/bin/hihy
		echoColor green "Done."
	fi

}

function hihyNotify(){
	localV=${hihyV}
	remoteV=`curl -fsSL https://git.io/hysteria.sh | sed  -n 2p | cut -d '"' -f 2`
	if [ -z $remoteV ];then
		echoColor red "Network Error: Can't connect to Github for checking hihy version!"
	else
		if [ "${localV}" != "${remoteV}" ];then
			echoColor purple "[Update] hihy has an update, version:v${remoteV}, it is recommended to update and check the log: https://github.com/emptysuns/Hi_Hysteria/commits/main"
		fi
	fi
	

}

function hyCoreNotify(){
	if [ -f "/etc/hihy/bin/appS" ]; then
  		localV=`/etc/hihy/bin/appS -v | cut -d " " -f 3`
		remoteV=`curl --head -s https://github.com/apernet/hysteria/releases/latest | grep -i location | grep -o 'tag/[^[:space:]]*' | sed 's/tag\///;s/ //g'`
		#Compatible with the v1 version update after the release of v2 (temporary, the next version will be removed)
		remoteV="v1.3.5"
		if [ -z $remoteV ];then
			echoColor red "Network Error: Can't connect to Github for checking the hysteria version!"
		else
			if [ "${localV}" != "${remoteV}" ];then
				echoColor purple "[Update] hysteria有更新,version:${remoteV}. 日志: https://github.com/apernet/hysteria/blob/master/CHANGELOG.md"
			fi
		fi
		
	fi
}


function checkStatus(){
	status=`systemctl is-active hihy`
    if [ "${status}" = "active" ];then
		echoColor green "hysteria正常运行"
	else
		echoColor red "Dead!hysteria未正常运行!"
	fi
}

function install()
{	
	if [ -f "/etc/systemd/system/hihy.service" ]; then
		echoColor green "你已经成功安装hysteria,如需修改配置请使用选项9/12"
		exit
	fi
	mkdir -p /etc/hihy/bin /etc/hihy/conf /etc/hihy/cert  /etc/hihy/result
    echoColor purple "Ready to install.\n"
    version=`curl --head -s https://github.com/apernet/hysteria/releases/latest | grep -i location | grep -o 'tag/[^[:space:]]*' | sed 's/tag\///;s/ //g'`
   #Compatible with the v1 version update after the release of v2 (temporary, the next version will be removed)
	version="v1.3.5"
	checkSystemForUpdate
	downloadHysteriaCore
	setHysteriaConfig
    cat <<EOF >/etc/systemd/system/hihy.service
[Unit]
Description=hysteria:Hello World!
After=network.target

[Service]
Type=simple
PIDFile=/run/hihy.pid
ExecStart=/etc/hihy/bin/appS --log-level info -c /etc/hihy/conf/hihyServer.json server
#Restart=on-failure
#RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF
    chmod 644 /etc/systemd/system/hihy.service
    systemctl daemon-reload
    systemctl enable hihy
    systemctl start hihy
	crontab -l > /tmp/crontab.tmp
	echo  "15 4 * * 1,4 hihy cronTask" >> /tmp/crontab.tmp
	crontab /tmp/crontab.tmp
	rm /tmp/crontab.tmp
	printMsg
	echoColor yellowBlack "安装完毕"
}


# 输出ufw端口开放状态
function checkUFWAllowPort() {
	if ufw status | grep -q "$1"; then
		echoColor purple "UFW OPEN: ${1}"
	else
		echoColor red "UFW OPEN FAIL: ${1}"
		exit 0
	fi
}

# 输出firewall-cmd端口开放状态
function checkFirewalldAllowPort() {
	if firewall-cmd --list-ports --permanent | grep -q "$1"; then
		echoColor purple "FIREWALLD OPEN: ${1}/${2}"
	else
		echoColor red "FIREWALLD OPEN FAIL: ${1}/${2}"
		exit 0
	fi
}

function allowPort() {
	# If the firewall is enabled, add the corresponding open port
	# $1 tcp/udp
	# $2 port
	if systemctl status netfilter-persistent 2>/dev/null | grep -q "active (exited)"; then
		local updateFirewalldStatus=
		if ! iptables -L | grep -q "allow ${1}/${2}(hihysteria)"; then
			updateFirewalldStatus=true
			iptables -I INPUT -p ${1} --dport ${2} -m comment --comment "allow ${1}/${2}(hihysteria)" -j ACCEPT 2> /dev/null
			echoColor purple "IPTABLES OPEN: ${1}/${2}"
		fi
		if echo "${updateFirewalldStatus}" | grep -q "true"; then
			netfilter-persistent save 2>/dev/null
		fi
	elif [[ `ufw status 2>/dev/null | grep "Status: " | awk '{print $2}'` = "active" ]]; then
		if ! ufw status | grep -q ${2}; then
			ufw allow ${2} 2>/dev/null
			checkUFWAllowPort ${2}
		fi
	elif systemctl status firewalld 2>/dev/null | grep -q "active (running)"; then
		local updateFirewalldStatus=
		if ! firewall-cmd --list-ports --permanent | grep -qw "${2}/${1}"; then
			updateFirewalldStatus=true
			firewall-cmd --zone=public --add-port=${2}/${1} --permanent 2>/dev/null
			checkFirewalldAllowPort ${2} ${1}
		fi
		if echo "${updateFirewalldStatus}" | grep -q "true"; then
			firewall-cmd --reload
		fi
	fi
}

function delPortHoppingNat(){
	# $1 portHoppingStart
	# $2 portHoppingEnd
	# $3 portHoppingTarget
	if systemctl status firewalld 2>/dev/null | grep -q "active (running)"; then
		firewall-cmd --permanent --remove-forward-port=port=$1-$2:proto=udp:toport=$3
		firewall-cmd --reload
	else
		iptables -t nat -F PREROUTING  2>/dev/null
		ip6tables -t nat -F PREROUTING  2>/dev/null
		if systemctl status netfilter-persistent 2>/dev/null | grep -q "active (exited)"; then
			netfilter-persistent save 2> /dev/null
		fi

	fi
}

function addPortHoppingNat() {
	# $1 portHoppingStart
	# $2 portHoppingEnd
	# $3 portHoppingTarget
	# If the firewall is enabled, delete the previous rule
	if [[ -n $(find /etc -name "redhat-release") ]] || grep </proc/version -q -i "centos"; then
		mkdir -p /etc/yum.repos.d

		if [[ -f "/etc/centos-release" ]]; then
			centosVersion=$(rpm -q centos-release | awk -F "[-]" '{print $3}' | awk -F "[.]" '{print $1}')

			if [[ -z "${centosVersion}" ]] && grep </etc/centos-release -q -i "release 8"; then
				centosVersion=8
			fi
		fi
		release="centos"
		installType='yum -y -q install'
		removeType='yum -y -q remove'
		upgrade="yum update -y  --skip-broken"
	elif grep </etc/issue -q -i "debian" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "debian" && [[ -f "/proc/version" ]]; then
		release="debian"
		installType='apt -y -q install'
		upgrade="apt update"
		updateReleaseInfoChange='apt-get --allow-releaseinfo-change update'
		removeType='apt -y -q autoremove'
	elif grep </etc/issue -q -i "ubuntu" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "ubuntu" && [[ -f "/proc/version" ]]; then
		release="ubuntu"
		installType='apt -y -q install'
		upgrade="apt update"
		updateReleaseInfoChange='apt-get --allow-releaseinfo-change update'
		removeType='apt -y -q autoremove'
		if grep </etc/issue -q -i "16."; then
			release=
		fi
	fi

	if [[ -z ${release} ]]; then
		echoColor red "\nThis script does not support this system, please feedback the log below to the developer\n"
		echoColor yellow "$(cat /etc/issue)"
		echoColor yellow "$(cat /proc/version)"
		exit 0
	fi

	if systemctl status firewalld 2>/dev/null | grep -q "active (running)"; then
		if ! firewall-cmd --query-masquerade --permanent 2>/dev/null | grep -q "yes"; then
			firewall-cmd --add-masquerade --permanent 2>/dev/null
			firewall-cmd --reload 2>/dev/null
			echoColor purple "FIREWALLD MASQUERADE OPEN"
		fi
		firewall-cmd --add-forward-port=port=$1-$2:proto=udp:toport=$3 --permanent 2>/dev/null
		firewall-cmd --reload 2>/dev/null
	else
		if ! [ -x "$(command -v netfilter-persistent)" ]; then
			echoColor green "*iptables-persistent"
			echoColor purple "\nUpdate.wait..."
			${upgrade}
			${installType} "iptables-persistent"
		fi
		if ! [ -x "$(command -v netfilter-persistent)" ]; then
			echoColor red "[Warnning]: The installation of netfilter-persistent failed, but the installation progress will not stop, but your PortHopping forwarding rule is a temporary rule, and restarting may fail. Do you want to continue to use the temporary rule? (y/N)"
			read continueInstall
			if [[ "${continueInstall}" != "y" ]]; then
				exit 0
			fi
		fi
		iptables -t nat -F PREROUTING  2>/dev/null
		iptables -t nat -A PREROUTING -p udp --dport $1:$2 -m comment --comment "NAT $1:$2 to $3 (PortHopping-hihysteria)" -j DNAT --to-destination :$3 2>/dev/null
		ip6tables -t nat -A PREROUTING -p udp --dport $1:$2 -m comment --comment "NAT $1:$2 to $3 (PortHopping-hihysteria)" -j DNAT --to-destination :$3 2>/dev/null
		
		if systemctl status netfilter-persistent 2>/dev/null | grep -q "active (exited)"; then
			netfilter-persistent save 2> /dev/null
		else 
			echoColor red "netfilter-persistent is not started, PortHopping forwarding rules cannot be persisted, restarting the system fails, please manually execute netfilter-persistent save, continue to execute the script without affecting subsequent configuration..."
		fi

	fi
    
}

function delHihyFirewallPort() {
	# If the firewall is enabled, delete the previous rule
	port=`cat /etc/hihy/conf/hihyServer.json | grep "listen" | awk '{print $2}' | tr -cd "[0-9]"`
	if [[ `ufw status 2>/dev/null | grep "Status: " | awk '{print $2}'` = "active" ]]	; then
		if ufw status | grep -q ${port}; then
			sudo ufw delete allow ${port} 2> /dev/null
		fi
	elif systemctl status firewalld 2>/dev/null | grep -q "active (running)"; then
		local updateFirewalldStatus=
		isFaketcp=`cat /etc/hihy/conf/hihyServer.json | grep "faketcp"`
		if [ -z "${isFaketcp}" ];then
			ut="udp"
		else
			ut="tcp"
		fi
		if firewall-cmd --list-ports --permanent | grep -qw "${port}/${ut}"; then
			updateFirewalldStatus=true
			firewall-cmd --zone=public --remove-port=${port}/${ut} --permanent 2> /dev/null
		fi
		if echo "${updateFirewalldStatus}" | grep -q "true"; then
			firewall-cmd --reload 2> /dev/null
		fi
	elif systemctl status netfilter-persistent 2>/dev/null | grep -q "active (exited)"; then
		updateFirewalldStatus=true
		iptables-save |  sed -e '/hihysteria/d' | iptables-restore
		if echo "${updateFirewalldStatus}" | grep -q "true"; then
			netfilter-persistent save 2>/dev/null
		fi
	fi
}

function checkRoot(){
	user=`whoami`
	if [ ! "${user}" = "root" ];then
		echoColor red "Please run as root user!"
		exit 0
	fi
}

function editProtocol(){
	# $1 change to $2, example(editProtocol 'udp' 'faketcp'): udp to faketcp
	portHoppingStatus=`cat /etc/hihy/conf/hihy.conf | grep "portHopping" | awk -F ":" '{print $2}'`
	portHoppingStart=`cat /etc/hihy/conf/hihy.conf | grep "portHoppingStart" | awk -F ":" '{print $2}'`
	portHoppingEnd=`cat /etc/hihy/conf/hihy.conf | grep "portHoppingEnd" | awk -F ":" '{print $2}'`
	serverPort=`cat /etc/hihy/conf/hihy.conf | grep "serverPort" | awk -F ":" '{print $2}'`
	sed -i "s/\"protocol\": \"${1}\"/\"protocol\": \"${2}\"/g" /etc/hihy/conf/hihyServer.json
	sed -i "s/\"protocol\": \"${1}\"/\"protocol\": \"${2}\"/g" /etc/hihy/result/hihyClient.json
	sed -i "s/protocol: ${1}/protocol: ${2}/g" /etc/hihy/result/metaHys.yaml
	sed -i "s/protocol=${1}/protocol=${2}/g" /etc/hihy/result/url.txt
	if echo "${portHoppingStatus}" | grep -q "true";then
		msg=`cat /etc/hihy/conf/hihy.conf | grep "serverAddress"`
		serverAddress=${msg#*:}
		delPortHoppingNat ${portHoppingStart} ${portHoppingEnd} ${serverPort}
		msg=`cat /etc/hihy/result/hihyClient.json | grep \"server\" | awk '{print $2}' | awk '{split($1, arr, ":"); print arr[2]}'`
		port_before=${msg::length-2}
		port_after=${msg%%,*}
		sed -i "s/\"server\": \"${serverAddress}:${port_before}\"/\"server\": \"${serverAddress}:${port_after}\"/g" /etc/hihy/result/hihyClient.json
		sed -i "s/mport=${portHoppingStart}-${portHoppingEnd}&//g" /etc/hihy/result/url.txt
		sed -i "s/\portHoppingStatus:true/portHoppingStatus:false/g" /etc/hihy/conf/hihy.conf
	fi
}

function changeMode(){
	if [ ! -f "/etc/hihy/conf/hihyServer.json" ]; then
		echoColor red "The configuration file does not exist, exit..."
		exit
	fi
	protocol=`cat /etc/hihy/conf/hihyServer.json  | grep protocol | awk '{print $2}' | awk -F '"' '{ print $2}'`
	echoColor yellow "当前使用协议为:"
	echoColor purple "${protocol}"
	port=`cat /etc/hihy/conf/hihyServer.json | grep "listen" | awk '{print $2}' | tr -cd "[0-9]"`
	if [ "${protocol}" = "udp" ];then
		echo -e "\033[32m\nPlease select the modified protocol type:\n\n\033[0m\033[33m\033[01m1, faketcp\n2, wechat-video\033[0m\033[32m\ n\nEnter serial number:\033[0m"
    	read pNum
		if [ -z "${pNum}" ] || [ "${pNum}" == "1" ];then
			echoColor purple "Choose to change the protocol type to faketcp."
			editProtocol "udp" "faketcp"
			delHihyFirewallPort
			allowPort "tcp" ${port}
		else
			echoColor purple "Choose to modify the protocol type to wechat-video."
			editProtocol "udp" "wechat-video"
		fi
	elif [ "${protocol}" = "faketcp" ];then
		delHihyFirewallPort
		allowPort "udp" ${port}
		echo -e "\033[32m\nPlease select the modified protocol type:\n\n\033[0m\033[33m\033[01m1, udp\n2, wechat-video\033[0m\033[32m\ n\nEnter serial number:\033[0m"
    	read pNum
		if [ -z "${pNum}" ] || [ "${pNum}" == "1" ];then
			echoColor purple "Choose to modify the protocol type to udp."
			editProtocol "faketcp" "udp"
		else
			echoColor purple "选择修改协议类型为wechat-video."
			editProtocol "faketcp" "wechat-video"
		fi
	elif [ "${protocol}" = "wechat-video" ];then
		echo -e "\033[32m\nPlease select the modified protocol type:\n\n\033[0m\033[33m\033[01m1, udp\n2, faketcp\033[0m\033[32m\n\ nEnter serial number:\033[0m"
    	read pNum
		if [ -z "${pNum}" ] || [[ "${pNum}" == "1" ]];then
			echoColor purple "Choose to modify the protocol type to udp."
			editProtocol wechat-video udp
		else
			delHihyFirewallPort
			allowPort "tcp" ${port}
			echoColor purple "Choose to change the protocol type to faketcp."
			editProtocol "wechat-video" "faketcp"
		fi
	else
		echoColor red "无法识别协议类型!"
		exit
	fi
	systemctl restart hihy
	echoColor green "modified successfully"
}


function generateMetaYaml(){
	if [[ ${4} == "" ]];then
		clashClient_auth_conf=$(cat <<- EOF
	obfs: ${12}
EOF
)
	else
		clashClient_auth_conf=$(cat <<- EOF
	auth_str: ${4}
EOF
)
	fi

	if [[ ${13} == "" ]];then
		port_conf=$(cat <<- EOF
	port: ${3}
EOF
)
	else
		port_conf=$(cat <<- EOF
	ports: ${13}-${14}
EOF
)
	fi

	cat <<EOF > /etc/hihy/result/metaHys.yaml
mixed-port: 7890
allow-lan: true
mode: rule
log-level: info
ipv6: true
dns:
  enable: true
  listen: 0.0.0.0:53
  ipv6: true
  default-nameserver:
    - 114.114.114.114
    - 223.5.5.5
  enhanced-mode: redir-host
  nameserver:
    - https://dns.alidns.com/dns-query
    - https://223.5.5.5/dns-query
  fallback:
    - 114.114.114.114
    - 223.5.5.5

proxies:
  - name: "$1"
    type: hysteria
    server: ${2}
    ${port_conf}
    ${clashClient_auth_conf}
    alpn:
      - h3
    protocol: ${5}
    up: ${6}
    down: ${7}
    sni: ${8}
    skip-cert-verify: ${9}
    recv_window_conn: ${10}
    recv_window: ${11}
    disable_mtu_discovery: true
    fast-open: true
proxy-groups:
  - name: "PROXY"
    type: select
    proxies:
     - $1

rule-providers:
  reject:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/reject.txt"
    path: ./ruleset/reject.yaml
    interval: 86400

  icloud:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/icloud.txt"
    path: ./ruleset/icloud.yaml
    interval: 86400

  apple:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/apple.txt"
    path: ./ruleset/apple.yaml
    interval: 86400

  google:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/google.txt"
    path: ./ruleset/google.yaml
    interval: 86400

  proxy:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/proxy.txt"
    path: ./ruleset/proxy.yaml
    interval: 86400

  direct:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/direct.txt"
    path: ./ruleset/direct.yaml
    interval: 86400

  private:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/private.txt"
    path: ./ruleset/private.yaml
    interval: 86400

  gfw:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/gfw.txt"
    path: ./ruleset/gfw.yaml
    interval: 86400

  greatfire:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/greatfire.txt"
    path: ./ruleset/greatfire.yaml
    interval: 86400

  tld-not-cn:
    type: http
    behavior: domain
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/tld-not-cn.txt"
    path: ./ruleset/tld-not-cn.yaml
    interval: 86400

  telegramcidr:
    type: http
    behavior: ipcidr
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/telegramcidr.txt"
    path: ./ruleset/telegramcidr.yaml
    interval: 86400

  cncidr:
    type: http
    behavior: ipcidr
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/cncidr.txt"
    path: ./ruleset/cncidr.yaml
    interval: 86400

  lancidr:
    type: http
    behavior: ipcidr
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/lancidr.txt"
    path: ./ruleset/lancidr.yaml
    interval: 86400

  applications:
    type: http
    behavior: classical
    url: "https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/applications.txt"
    path: ./ruleset/applications.yaml
    interval: 86400

rules:
  - RULE-SET,applications,DIRECT
  - DOMAIN,clash.razord.top,DIRECT
  - DOMAIN,yacd.haishan.me,DIRECT
  - DOMAIN,services.googleapis.cn,PROXY
  - RULE-SET,private,DIRECT
  - RULE-SET,reject,REJECT
  - RULE-SET,icloud,DIRECT
  - RULE-SET,apple,DIRECT
  - RULE-SET,google,DIRECT
  - RULE-SET,proxy,PROXY
  - RULE-SET,direct,DIRECT
  - RULE-SET,lancidr,DIRECT
  - RULE-SET,cncidr,DIRECT
  - RULE-SET,telegramcidr,PROXY
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
EOF
}

function checkLogs(){
	echoColor purple "hysteria real-time log, level: info, press Ctrl+C to exit:"
	journalctl -u hihy --output cat -f
}

function cronTask(){
	systemctl restart hihy #防止hysteria占用内存过大
	systemctl restart systemd-journald #防止日志占用内存过大
}

function start(){
	systemctl start hihy
	echoColor purple "start..."
	sleep 5
	status=`systemctl is-active hihy`
	if [ "${status}" = "active" ];then
		echoColor green "Start successfully"
	else
		echoColor red "启动失败"
		echo -e "Unknown error: please run manually:\033[32m/etc/hihy/bin/appS -c /etc/hihy/conf/hihyServer.json server\033[0m"
		echoColor red "Check error log, feedback to issue!"
	fi
}

function stop(){
	systemctl stop hihy
	echoColor green "paused successfully"
}

function restart(){
	systemctl restart hihy
	echoColor purple "restart..."
	sleep 5
	status=`systemctl is-active hihy`
	if [ "${status}" = "active" ];then
		echoColor green "restart successful"
	else
		echoColor red "Restart failed"
		echo -e "Unknown error: please run manually:\033[32m/etc/hihy/bin/appS -c /etc/hihy/conf/hihyServer.json server\033[0m"
		echoColor red "Check error log, feedback to issue!"
	fi
}

function menu()
{
hihy
clear
cat << EOF
-----------------------------------------------
|********** Hi Hysteria ***********|
|********** Author: emptysuns ***********|
|********** Version: `echoColor red "${hihyV}"` ***********|
  -----------------------------------------------
Tips: The `echoColor green "hihy"` command runs the script again.
`echoColor skyBlue "................................................" `
`echoColor purple "#################################"`

`echoColor skyBlue "................................"`
`echoColor yellow "1) install hysteria"`
`echoColor magenta "2) Uninstall"`
`echoColor skyBlue "................................"`
`echoColor yellow "3) start"`
`echoColor magenta "4) pause"`
`echoColor yellow "5) restart"`
`echoColor yellow "6) Running status"`
`echoColor skyBlue "................................"`
`echoColor yellow "7) Update Core"`
`echoColor yellow "8) View current configuration"`
`echoColor skyBlue "9) Reconfigure"`
`echoColor yellow "10) switch ipv4/ipv6 priority"`
`echoColor yellow "11) update hihy"`
`echoColor red "12) Complete reset of all configurations"`
`echoColor skyBlue "13) Modify the current protocol type"`
`echoColor yellow "14) View real-time logs"`

`echoColor purple "#################################"`
`hihyNotify`
`hyCoreNotify`

`echoColor magenta "0) exit"`
`echoColor skyBlue "................................................" `
EOF
read -p "请选择:" input
case $input in
	1)	
		install
	;;
	2)
		uninstall
	;;
	3)
		start
	;;
	4)
		stop
	;;
    5)
        restart
    ;;
    6)
        checkStatus
	;;
	7)
		updateHysteriaCore
	;;
	8)
		printMsg
    ;;
    9)
        changeServerConfig
    ;;
	10)
        changeIp64
    ;;
	11)
        hihyUpdate
		
    ;;
	12)
        reinstall
	;;
	13)
        changeMode
	;;
	14)
		checkLogs
    ;;
	0)
		exit 0
	;;
	*)
		echoColor red "Input Error !!!"
		exit 1
	;;
    esac
}

checkRoot
if [ "$1" == "install" ] || [ "$1" == "1" ]; then
echoColor purple "-> 1) install hysteria"
install
elif [ "$1" == "uninstall" ] || [ "$1" == "2" ]; then
echoColor purple "-> 2) Uninstall hysteria"
uninstall
elif [ "$1" == "start" ] || [ "$1" == "3" ]; then
echoColor purple "-> 3) start hysteria"
start
elif [ "$1" == "stop" ] || [ "$1" == "4" ]; then
echoColor purple "-> 4) suspend hysteria"
stop
elif [ "$1" == "restart" ] || [ "$1" == "5" ]; then
echoColor purple "-> 5) restart hysteria"
restart
elif [ "$1" == "checkStatus" ] || [ "$1" == "6" ]; then
echoColor purple "-> 6) Running status"
checkStatus
elif [ "$1" == "updateHysteriaCore" ] || [ "$1" == "7" ]; then
echoColor purple "-> 7) Update Core"
updateHysteriaCore
elif [ "$1" == "printMsg" ] || [ "$1" == "8" ]; then
echoColor purple "-> 8) View the current configuration"
printMsg
elif [ "$1" == "changeServerConfig" ] || [ "$1" == "9" ]; then
echoColor purple "-> 9) Reconfiguration"
changeServerConfig
elif [ "$1" == "changeIp64" ] || [ "$1" == "10" ]; then
echoColor purple "-> 10) switch ipv4/ipv6 priority"
changeIp64
elif [ "$1" == "hihyUpdate" ] || [ "$1" == "11" ]; then
echoColor purple "-> 11) update hihy"
hihyUpdate
elif [ "$1" == "reinstall" ] || [ "$1" == "12" ]; then
echoColor purple "-> 12) Completely reset all configurations"
reinstall
elif [ "$1" == "changeMode" ] || [ "$1" == "13" ]; then
echoColor purple "-> 13) Modify the current protocol type"
changeMode
elif [ "$1" == "checkLogs" ] || [ "$1" == "14" ]; then
echoColor purple "-> 14) View real-time logs"
checkLogs
elif [ "$1" == "cronTask" ]; then
cronTask
else
menu
  fi
