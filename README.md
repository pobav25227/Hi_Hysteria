# Hi Hysteria

##### (2023/09/02) 0.4.9

```
1. Fix hysteria v1 version number recognition bug after v2 release

Q: When will hysteria v2 be compatible?
A: Because hysteria v2 has just released the official version for a few hours, only the sing-box beta version supports it, and v1 and v2 are not compatible with each other
The client is not well adapted, 0.4.9 is not ready yet, the next version 0.5.0 will be compatible with both v1 and v2 versions (update as soon as possible)
The changes in v1 and v2 are quite big, if you want to try it out, you can manually configure it first
```
[Hysteria V2 protocol support](https://github.com/emptysuns/Hi_Hysteria/issues/263)

[Historical improvements](md/log.md)

## 1. Introduction

> Hysteria is a feature-rich network tool (two-way acceleration) optimized for harsh network environments, such as satellite networks, crowded public Wi-Fi, connecting to foreign servers in **China**, etc. Based on a modified version of the QUIC protocol.

Hysteria is a very good "lightweight" proxy program written by go, which solves the biggest pain point when building a powerful magic server - **line crossing**.

The most difficult thing in the magic chant is not the construction and maintenance, but the delivery quality during the evening peak period. ~~When the three major operators Wangao became: Dianxin, Impossible, Immovable, you and I both felt. ~~ Although it uses udp but provides obfs, it will not be subject to targeted QoS by operators for the time being (if you do not enable obfs, you will not be subject to QoS).

1. Bench provided by the original project:

![image](https://raw.githubusercontent.com/HyNetwork/hysteria/master/docs/bench/bench.png)

2. 50mbps Northern Telecom, Beijing exit, directly connected to line 163 in the vir San Jose computer room, and tested YT 1080p60 live stream at 22-23 o'clock:

![image](imgs/speed.png)

```
190 dropped of 131329
```

3. Optimization of Zhongguo mainland line, Los Angeles shockhosting computer room, 1c128m ovznat 4k@p60:
![image](imgs/yt.jpg)

```
139783 Kbps
```

This project is only for learning purposes, please delete and stop using it immediately within 5 seconds.

The author does not assume the risk and any legal responsibility for any problems caused by it.

Because the script is currently in the test version of 0.x, there may be some bugs, if you encounter them, please send an issue, welcome to star, your ⭐ is the motivation for my maintenance.

Adapt to ubuntu/debian, centos/rhel operating system, misple/arm/x86/s390x architecture.

## Two. Use

### First time use?

#### 1. [Firewall issues](md/firewall.md)

#### 2. [Self-signed certificate](md/certificate.md)

#### 3. [Restricted UDP service provider demining list [2023/01/26 update]](md/blacklist.md)

#### 4. [Introduction to protocols in hysteria](md/protocol.md)

#### 5. [How to set my delay, uplink/downlink speed? ](md/speed.md)

#### 6. [Supported clients](md/client.md)

#### 7. [FAQ](md/issues.md)

#### 8. [[Port Hopping/Multiple Ports](Port Hopping) Introduction](md/portHopping.md)

### pull install

```
su - root #switch to root user.
bash <(curl -fsSL https://git.io/hysteria.sh)
```

### Configuration process

After the first installation: `hihy` command brings up the menu, if the hihy script is updated, please execute option `9` or `12` to get the latest configuration

```
  -----------------------------------------------
|********** Hi Hysteria ***********|
|********** Author: emptysuns ***********|
|********** Version: 0.4.6 ***********|
  -----------------------------------------------
Tips: run the script again with the hihy command.
...................................................
#################################

...................................
1) Install hysteria
2) Uninstall
...................................
3) start
4) pause
5) reboot
6) Running status
...................................
7) Update Core
8) View the current configuration
9) Reconfigure
10) Switch ipv4/ipv6 priority
11) Update hihy
12) Completely reset all configurations
13) Modify the current protocol type
14) View real-time logs

#################################


0) exit
...................................................
please choose:
```

**The script may change every time it is updated, please be sure to expand and refer to the demo process carefully to avoid unnecessary mistakes! **

<details>
   <summary>The demo is long, click me to view</summary>
<pre><blockcode>
Start configuration:
Please choose the certificate application method:

1. Use ACME to apply (recommended, you need to open tcp 80/443)
2. Use a local certificate file
3. Self-signed certificate

Enter serial number:
3
Please enter the domain name of the self-signed certificate (default: wechat.com):
Note: Self-signed certificates have been randomly blocked in recent times, please use them with caution (this prompt does not disappear, indicating that the blocking is still going on)
If you must use a self-signed certificate, please choose to use obfs obfuscated verification in the configuration below to ensure security
fuck.qq.com
Judging the self-signed certificate, whether the address used by the client connection is correct? Public network ip: 1.2.3.4
please choose:

1. Correct (default)
2. Incorrect, manually input ip

Enter serial number:
1

->You have chosen self-signed fuck.qq.com certificate encryption. Public network ip: 1.2.3.4

Select the protocol type:

1. udp (QUIC, can start port jumping)
2. faketcp
3. wechat-video (default)

Enter serial number:
3

->Transmission protocol: wechat-video

Please enter the port you want to open. This port is the server port. It is recommended to be 10000-65535. (Random by default)

-> Use random port: udp/14274

Please enter your average delay to this server, which is related to the forwarding speed (default 200, unit: ms):
180

-> Latency: 180 ms

Expected speed, which is the peak speed of the client, and the server is not limited by default. Tips: The script will automatically *1.10 for redundancy. If your expectation is too low or too high, it will affect the forwarding efficiency. Please fill in truthfully!
Please enter the downlink speed expected by the client: (default 50, unit: mbps):
180

-> Client downlink speed: 180 mbps

Please enter the client's expected uplink speed (default 10, unit: mbps):
30

->Client uplink speed: 30 mbps

Please enter the authentication password (randomly generated by default, a strong password of more than 20 characters is recommended):

-> Authentication password: Wvb9NlmWt0BxkJXoLnYKvM0NoOUz6sIgdaWHDr1gMzQGtE8lIs

Tips: If obfs obfuscated encryption is used, the anti-blocking ability is stronger, and it can be recognized as unknown udp traffic, but it will increase the CPU load and cause the peak speed to drop. If you are pursuing performance and have not been targeted for blocking, it is recommended not to use it
Choose a verification method:

1. auth_str (default)
2. obfs

Enter serial number:
2

->The verification method you choose is: obfs

Please enter the client name for remarks (by default, the domain name/IP is used to distinguish, for example, if you enter test, the name is Hys-test):
demo

Configuration entry is complete!

Execute configure...
SIGN...

Signature ok
subject=C = CN, ST = GuangDong, L = ShenZhen, O = PonyMa, OU = Tecent, emailAddress = admin@qq.com, CN = Tencent Root CA
Getting CA Private Key
rm: cannot remove '/etc/hihy/cert/fuck.qq.com.ca.srl': No such file or directory
SUCCESS.

net.core.rmem_max = 8000000

Test config...

IPTABLES OPEN: udp/14274
Test success!
Generating config...
The installation is successful, please check the configuration details below
docker.sh: line 877: 27670 Killed /etc/hihy/bin/appS -c /etc/hihy/conf/hihyServer.json server > /tmp/hihy_debug.info 2>&1

1* [v2rayN/nekoray] Use hysteria core to run directly:
The client configuration file is output to: /root/Hys-demo(v2rayN).json (directly download the generated configuration file [recommended] / copy and paste the configuration below to local)
Tips: The client only enables http(8888) and socks5(8889) proxies by default! For other methods, please refer to the hysteria documentation to modify the client config.json by yourself
↓***********************************↓↓↓copy↓↓↓******** *************************↓
{
"server": "1.2.3.4:14274",
"protocol": "wechat-video",
"up_mbps": 33,
"down_mbps": 198,
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
"obfs": "Wvb9NlmWt0BxkJXoLnYKvM0NoOUz6sIgdaWHDr1gMzQGtE8lIs",
"auth_str": "",
"alpn": "h3",
"acl": "acl/routes. acl",
"mmdb": "acl/Country.mmdb",
"server_name": "fuck.qq.com",
"insecure": true,
"recv_window_conn": 18612224,
"recv_window": 74448896,
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
↑********************************** ↑↑↑copy↑↑↑******** *******************
