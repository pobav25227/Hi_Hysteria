##### (2023/06/12) 0.4.8:

```
hysteria update to v1.3.5:
v1.3.5 fixes a socks5 bug in domain name resolution, supports colored characters under windows cmd, and has no important function updates

Q: Hy 1.x version will not have any major function updates?
A: Hysteria 1.x will continue to release bugs and security fixes. Now the focus of development is on hy2. At present, the functions of hy1 are very complete. There is no difference between hy1 and hy2 in terms of speed. The difference is that hy2 pays more attention to traffic and http/3 traffic. It can realize the function of falling back to the web similar to xray, but there is no guarantee that the udp traffic will not be blocked, so it is currently in the testing stage, and the actual effect remains to be seen

Q: When will hihy support hy2?
A: hy2 is currently in the testing state. Many functions of hy1 are not supported by hy2, and the client can only be used with the command line. Wait for hy2 to release the first complete public version before considering adaptation

1. Fix the problem that the correct hysteria version number cannot be obtained because the server ip is too dark
2. matsuri will not release major function updates, and Android users are advised to choose its "upgraded version" nekobox
https://github.com/MatsuriDayo/NekoBoxForAndroid
```


##### (2023/03/15) 0.4.7

```
hysteria update to 1.3.4 : Fixed some bugs, updated dependencies, the client provides the lazy_start option, only connects to the server when incoming data, client functions

1. The client adds lazy_start configuration. Currently, it only supports v2rayN, a client that uses the core to run directly. Others will be added after the subsequent version is packaged.
2. Increase net.core.rmem_max
3. Increase the waiting time for configuration testing by 5 seconds, because there may be a delay in ACME certificate application to prevent configuration detection failures
4. Improve the client introduction document

Tips: It is observed that the operator’s UDP QoS rules are frequently triggered after lazy_start is turned on. For safety, it is temporarily disabled by default after 0.4.7.a
If you need to test, please manually add the client option `"lazy_start": true`, follow up later
```

##### (2023/02/17) 0.4.6

```
hysteria update to 1.3.3 : fixed some bugs, updated dependencies to improve performance

1. Fix the problem that when PortHopping is not used, a - character appears in the generated link, resulting in an abnormal import
2. Cancel the server configuration resovler option, and use the system dns address by default
3. V2rayN chooses to use version 6.0 or above
4. Compatible with clash.meta port jumping and TCP fast opening
```

##### (2022/12/11) 0.4.5.b

```
1. Support obfs configuration, if you use a self-signed certificate, please try to use obfs to confuse
2. Fix random password garbled problem
3. Add the command direct function, map the digital serial number, for example, hihy 5 will restart the server, hihy 14 will print the log
4. Modify the server DoH to DNS 53
5. Add a TG communication group link in the FAQ, which is intended to communicate and solve various problems that arise during use
https://hihysteria.t.me/
6. Compatible with Masturi, shadowrocket, one-click link configuration port jumping parameters
```

##### (2022/12/04) 0.4.4.m

```
Hysteria 1.3.1 is released, which supports fast_open to speed up the response and improve a little performance (currently fast_open is only applicable to the direct operation mode of the hysteria kernel (V2rayN), and other clients do not directly support it)
1. Support comments on configuration
2. Added reminders for self-signed certificates. Recently, GFW has seriously blocked self-signed certificates and is no longer recommended.
3. Added some prompt information to facilitate the configuration process
4. Add random password function
5. Improve the support for PortHopping, fix the bug that iptables rules disappear after restarting the system
6. Fix the bug that the download is empty when the ip is blocked by github and the hysteria core cannot be obtained
7. Increase the detection after restarting hysteria, and fix the bug that prompts success when restarting fails
8. Fix the bug that netfilter-persistent rules cannot be deleted
9. Some other bug fixes
10. Support fast_open
11. Add other client downloads on the release to facilitate direct access
12. Fix the bug that lsof does not distinguish between port type and listening status
13. Improve the judgment of port legitimacy and guide users to input the correct port as much as possible
14. Modify the test configuration method to speed up the configuration printing time
15. Fix the way of real-time log printing, use redirection to cat to prevent untimely update

Q: Why is 0.4.4 updated so frequently and with so much content?
A: In the last version, a lot of ancestral codes were moved to be compatible with portHopping, resulting in a bunch of bugs, so there are more fixes
```

##### (2022/11/08) 0.4.3.c

**The original warehouse of hysteria was renamed from [@HyNetwork](https://github.com/HyNetwork/hysteria) to [@apernet](https://github.com/apernet/hysteria), please be lower than 0.4.3. Users of the c version can use it after updating, otherwise the core information cannot be obtained and the installation will fail!!!**

```
1. Hysteria 1.3.0 is released, which supports multi-port monitoring function (only supported by UDP protocol), and can switch without sense to prevent problems such as single-port QoS/disconnection
For details, please refer to: https://github.com/emptysuns/Hi_Hysteria/blob/main/md/portHopping.md
2. Fix the remaining bugs when switching protocols in the previous version
3. Modify some text colors to make the printed results clearer
4. After clash.meta 1.13.2, the alpn configuration becomes an array. If your version is lower than 1.13.2, you may need to update your client to support the latest configuration
Details: https://docs.metacubex.one/function/proxy/hysteria
5. Fix the bug that the protocol type is misjudged when port hopping is started
```

#### (2022/10/28) 0.4.2:

```
Note: hysteria 1.2.2 adds heartbeat detection configuration, if v2rayN wants to use the latest hihy configuration, please update hysteria to 1.2.2 or above, otherwise it will not be compatible with the latest configuration

1. The menu provides the function of viewing logs
2. Fix the bug that the print result is not synchronized after modifying the protocol type
3. Added heartbeat detection configuration
    Tip: It is only applicable to v2rayN, which runs directly through the hysteria kernel
         Clash-Meta/passwall is not adapted, nekoray needs to be added manually, one-click link does not support import
4. Reduce the increased bandwidth redundancy and prevent the redundancy increment from being too high when the bandwidth is too large
5. Modify the restart service interval to one week
```

#### (2022/09/10) 0.4.1:

```
Notice: Please use wechat-video and users whose hysteria Core version is lower than 1.2.1 update the dual-end
Because hysteria 1.2.1 fixed the bug that caused wechat-video to fail if obfs was not enabled, if it is not updated
will result in a failure to connect

1. Reduce the waiting time when configuring detection, and increase the time waiting for the detection process to close
2. Add FAQ
```

#### (2022/08/14) 0.4.0

```
[If v2rayN uses the latest configuration, please update the client, clash_meta does not affect]:
1. Compatible with hysteria 1.2.0 resolver and tun configuration changes
2. Use DoH to replace the original dns request through udp 53 plaintext to increase security
3. Improve the instructions on supporting clients
```

#### (2022/07/07) 0.3.9

```
  [It is strongly recommended to update server and client]:
1. Support exporting a clash.meta configuration file. As the client core, clash.meta has many advantages over hysteria. For details, see the introduction. [recommended/beta-ing...]
2. Modify the generation source of acl rules, convert long-term maintenance and update clash shunt rules into hysteria acl rules, and repair 0.3.8.1 acl shielding rules
3. The hysteria milestone is updated to 1.1.0, the cpu overhead is reduced, and the speed is increased by at least 130%-500%. Chuan strongly recommends updating both ends
4. Modify the print style of the result to be more clearly visible
```

#### (2022/06/26) 0.3.8

```

1. Add i686 architecture adaptation
2. Add the detection that port 443 80 is occupied by other processes and cannot apply for a certificate, prompt information and give the option to stop the process
    (Not recommended, it is best to use a self-signed certificate or choose a local certificate here)
3. Adjustment menu
4. bug fixed
5. Provide clash-meta support (cuckoo)
```

#### (2022/05/14) 0.3.7

```

1. Compatible with hysteria 1.0.4, and shield udp/443 output at the same time (since hysteria has no acceleration effect on udp at present, it prevents web pages from slowing down by http/3)
2. Add the function of modifying the current protocol, no need to repeat the installation
3. Compatible with v2rayN, no longer optimized for cmd client
```

#### (2022/04/28) 0.3.6

```

1. Identify the system default firewall management port, no longer install netfilter-persistent
2. Provide the certificate encryption method under the local path, which can be uploaded to the server by itself for trusted certificate encryption
3. Open custom self-signed certificate domain names
4. Modify the buffer size calculation
5. git.io was flooded by a large number of academic personnel yesterday. Under pressure, the existing rules will not be stopped, but it is still readable. The project is still changed back to the original short link, and I was repeatedly jumped by it: )
```

#### (2022/04/18) 0.3.5

```

1. Improve the process of opening firewall ports to lay the foundation for further subdivision of ports in the future
2. Add s390x architecture adaptation
3. Added instructions for v2rayN [TEST]
```

#### (2022/04/12) 0.3.4

```
[Please update via the "Reinstall/Upgrade" option]
1. Fix the disconnection problem in high packet loss environment
2. Align menu
3. Increase the command detection instead of repeating the install every time the configuration is modified
```

#### (2022/04/01) 0.3.3

```
[Please update via the "Reinstall/Upgrade" option]
1. Fix the bug that the configuration file cannot be printed
2. Add the "Modify current configuration" option, no need to repeat the installation
3. Add hihy and hysteria update prompts and manual update options
4. Optimize the directory structure on the server side to pave the way for future updates
```

#### (2022/03/28) 0.3.2

```

1. update hysteria to 1.0.2
2. Support to adjust ipv4/ipv6 priority
3. Fix the bug that the installation fails without lsof
```

#### (2022/03/24) 0.3.1

```

1. Change the daemon process name to hihy again, which is easier to remember than the original hihys and hysteria
2. Fix the bug that the previous version of hysteria cannot be uninstalled in 0.3.0
3. Add the configuration detection function before creating the daemon process to prevent users who fail ACME from jumping repeatedly.
4. Make the menu clearer
```

#### (2022/03/21) 0.3.0

```
(more improvements this time):
1· Added "menu" function, updated to version 0.3.0, and then use the hihys command to call up the menu
2. Centralize the dependent installation into the script, no need for manual installation, and improve the system detection process
3. Add a one-click link to generate a small rocket
4. Optimized script prompts, rewritten part of the code, more convenient to add new functions
5. Improve the introduction part of the readme to make it easier to understand, and add the example picture of passwall
6. Add "advanced gameplay (pseudo") to introduce some other gameplay
7. The daemon name is replaced by hihys hysteria
8. Canceled the S5 default configuration with password
```

#### (2022/02/20 17:26) v0.2.9

```
(The old client is not compatible with the new server, it is recommended to update it together)
1. hysteria->1.0.1 hi_hysteria_cmd 0.2h, skip version 1.0.0, s5There is a bug in the stack
Version 1.0.1 adds fragmentation and reassembly of large udp packets, further enhancing efficiency
The new s5 outbound can be used with warp or xray for shunting, but there is no good idea at present, so I will dove first.
2. New automatic release firewall
```

#### (2022/02/20 17:26) v0.2.8

```

1. hysteria->0.9.7 hi_hysteria_cmd 0.2g
2. PMTUD is back, it is recommended to upgrade
3. When self-signing the certificate, change it back to the default "Allow unsafe connections". For details, refer to the introduction below
```

#### (2022/02/04 15:42) v0.2.7

```
(Want to update to this version, not backwards compatible)
1. update hysteria->0.9.6, hi_hysteria 0.2f
2. The upstream quic-go does not fix bugs, hysteria temporarily disables PMTUD, and deletes the original disable_mtu_discovery option, which is always true to alleviate the disconnection problem
3. Add support for reconnection option, try 5 times by default with an interval of 3s
4. Open a new section and issue, collect IDCs and prefecture-level operators that restrict udp transmission, and clear mines for everyone. If you find any, please reply to the issue information ou, thank you ~.
(Restricted udp transmission, mainly for the normal startup of the server, but the client shows that the network is unreachable)
```

#### (2022/01/10 17:40) v0.2.6

```

1. hi_hysteria 0.2e
2. Acl rules are merged and replaced by geoip (looking forward to geosite
3. Change the self-signing to wechat.com, cancel the permission of unsafe links, and check the self-signing instructions in detail
```

#### (2022/01/04 21:59) v0.2.5

```

1. The version of hysteria has been upgraded to 0.9.3, please re-download "cmd client", version:0.2d
!
Since the original project uses the github action to compile the version with tun, the latest GLIBC_2.32 is used
Many systems are currently not well supported and have dependency issues
So I compiled v0.9.3 amd64 myself, as a temporary workaround.
!
2. Add wechat video call traffic camouflage
3. Add the introduction of each protocol type to readme
4. Cancel the obfs option support (it is not necessary to enable it, when your network environment restricts QUIC transmission, you can add it yourself), greatly reduce the CPU overhead and increase the speed
```

#### (2021/12/19 21:16) v0.2.4

```

1. The hysteria version has been upgraded to 0.9.1, please re-download the "cmd client", version:0.2c
2. Add faketcp mode configuration, for details, please check: "Note before use" item
3. The outbound was pigeonholed
4. The client adds socks5 (port: 8889) proxy mode, user: pekora; password: pekopeko. You can modify the user password by yourself
5. Add custom dns such as 8.8.8.8 to prevent carrier dns hijacking attacks
```

#### (2021/12/10 18:59) v0.2.3a

```

1. The version of hysteria has been upgraded to 0.9.0, please re-download the "cmd client", version: 0.2b (Note: because the new feature ipv6_only of 0.9.0 cannot resolve ipv4, you can wait for the outbound supported by the next version features, which are not added here
2. Refresh the acl.
```

#### (2021/11/26 10:30) v0.2.3

```

1. Alpn changed to h3 (although it is not necessary)
2. The version of hysteria has been upgraded to 0.8.6, please re-download "cmd client?!", version:0.2a
```

#### (2021/11/08 19:50) v0.2.2

```

1. Integrate self-signed/ACME
2. Change the buffer calculation method to improve the speed
3. Fix multi-symbol bug when self-signed ipv6
4. Add random port function
5. Increase the function of automatically restarting the server every day to prevent excessive memory usage
```

#### (2021/11/06 21:16) v0.2.1

```

1. Provide self-signed certificate installation, so that some ACME cannot verify users
```

#### (2021/10/05 18:36) v0.2

```

1. Optimize the client (!?) structure
2. Increase background running function
```

#### (2021/10/04 16:19) v0.1

```

1. Fix the bug that cannot be proxied due to dns pollution and add the rule of removing advertisements
2. Add arm and mipsle architecture adaptation
3. Increase client foolproof
```
