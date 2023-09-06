## FAQ/Notice

### The FAQ given below can't solve your query?

A TG group was created upon request to help everyone exchange problems encountered in the process of using hysteria

https://hihysteria.t.me/

### Keep important notices on file

There may be tips for you to solve the problem here. Sometimes the new version of hysteria configuration is not compatible with the old version, resulting in an error

**A lot of times there is a problem, updating the server and client configuration can solve it**

#### (2022/09/10):

Please use wechat-video and users whose hysteria Core version is lower than 1.2.1 update the dual-end

Because hysteria 1.2.1 fixed the bug that caused wechat-video to fail if obfs was not enabled, if it is not updated
will result in a failure to connect

### common problem

Here are some common problems about the use of hihy. If you encounter them, please don’t rush to open an issue. Please look here and maybe you can solve them. ~~ Don't open any more meaningless issues~~

#### 1. What should I do if the hysteria speed cannot be increased?

This question is very general. You need to know that both the client and the server have bottlenecks. If extremely high network bandwidth is required, both the server and the client must have corresponding hardware support and bandwidth support.

QUIC has a lot more hardware overhead than native TCP, and often it is your CPU that limits you

If you are using the udp protocol (wechat-video/udp), you need to ensure that your local ISP does not restrict udp transmission, and a small number of IDC providers will also restrict udp to prevent users from abusing it.

Don’t fill in the uplink bandwidth and downlink bandwidth casually, fill in according to your real level, if it is greater than your cpu processing ability and network bandwidth ability, you will also have this problem

Finally, for some lxc/openvz virtualization, `net.core.rmem_max` cannot be changed, which will not support well when filling too high bandwidth

#### 2. What should I do if I have been unable to connect? What should I do if the connection error is reported? /What if it works sometimes and sometimes doesn't?

First of all, you need to ensure that your server can start normally

Secondly, you can ensure that your client configuration does not report errors

If the log still shows `[error:timeout: no recent network activity] Failed to initialize client`

Please check if your IDC is in [Blacklist](blacklist.md), if none of the above is satisfied, please see below

* You have not opened the firewall of the cloud platform. In many cases, the local firewall and the cloud firewall are separated. hihy will automatically open the local firewall. The cloud firewall needs to be started manually. See [here] (firewall.md) for the startup instructions.
* Your local ISP is strictly restricted and cannot pass the unconventional udp protocol, please switch the protocol type to try or use faketcp
* I didn't notice the configuration error, please check it again
* Your IDC has not been collected by the blacklist, please submit it here [issue](https://github.com/emptysuns/Hi_Hysteria/issues/9)

#### 3. What should I do if the system is not supported?

Your system is too old and is not a version maintained by the mainstream community. For example, the software update source no longer supports updates. It is difficult to support this kind of system with scripts alone. Here we can solve it by ourselves.

Or your system has been magically modified by the service provider, hihy cannot recognize the system type, so the next steps cannot be performed, and an error will also be reported

For this kind of problem, please install it yourself as the current mainstream mirror image. There are many methods that will not be explained here.

#### 4. The script cannot be started normally

Every time you run `hihy`, you need to get the latest information through github, your ip may be blocked by github or you cannot connect to github at all

#### 5. Will I be blocked if I use hysteria?

It has not been targeted at present, and I don’t know what will happen in the future. Even if it is targeted because it is an open source project, many people will contribute code to fight against the blockade. Refer to ss next door. Thanks to the developers of hysteria for their selfless contributions.

#### 6. Sagernet / Matsuri cannot connect

Please install Hysteria-plugin on github or google play store and **allow it to be started by other apps**
It is not recommended to use sagernet now, it has stopped updating for a long time, it is recommended to use Matsuri

#### 7. The cpu usage is so high, hihy won't hide mining, right?

:)

All slag codes are not encrypted, and the git.io used by the short link cannot return different values depending on the client

That is, ** can be checked, and the old and the old are not deceived**

High occupancy is the characteristic of QUIC

#### 8. How to choose whether to use obfs confusion

obfs is an option used to confuse traffic into unknown traffic. Turning it on will resist blocking to the greatest extent, but it has advantages and disadvantages
advantage:

1. Anti-blocking
2. Strong security for unknown traffic
3. It can hide certificate handshake information and can be used in conjunction with self-signed certificates

shortcoming:

1. The CPU overhead is high, and if the performance is not good, it will affect the speed
2. For some IDCs with protocol whitelists, unknown udp traffic is often considered an attack and blocked, and the client cannot connect to the server

#### 9. Questions about self-signed certificates

At present, the CA used by the self-signed certificate is fixed, it is Tencent Root CA, which is definitely illegal

There was no problem with using self-signed certificates some time ago, but since 202210, it has been observed that the flow of self-signed certificates will be blocked on a certain scale, that is to say, the flow will be cut off

So when you want a self-signed certificate, I recommend you to use obfs, which compromises performance in exchange for stability

If possible, it is recommended to use sing-box to configure hysteria to use shadow-tls


#### 10. Recent UDP blocking phenomenon

Note: The following content has not undergone a lot of investigation, just talk about the situation I encountered, for reference only

As we all know, GFW is a black box, we can only explain some phenomena by guessing

Hysteria is used now, and it should be targeted by it

Different operators in different regions have different strategies for UDP. For example:

It may be that the telecom in the same area is fine, but there is something wrong with mobile

Telecom in Beijing is fine, Telecom in Shanghai is in trouble

I can't help you summarize this, you can only test it yourself, in general, at least faketcp has the bottom line

Let me describe the problem of udp being restricted that I encountered:

* Protocol: wechat-video

* Certificate: Trusted certificate applied by ACME

* Whether multi-port: No

* Whether to use obfs obfuscation: No
* Network: Telecom -> a cold computer room
* Phenomenon: Server A was set up with hihy, and it has been used for several months. **It has always been a single-port connection**. Then it suddenly found that it could not be used. After changing to other nodes, it was blocked again after a short period of time. Udp Can't connect, faketcp is fine

This phenomenon was solved after using PPPoE to re-dial up the network, and then it was used normally the next day, and the same phenomenon appeared again during the evening peak (around nine o’clock).

Specifically, all udp connections are blocked in a **short period of time** after the **connection is successful**, and changing nodes is invalid, **regardless of the changed nodes (servers B, C, D, are other Computer room) Whether obfs is used, whether it is multi-port, only faketcp can connect to **.

Later I** changed the protocol to udp and enabled obfs** still the same phenomenon

* Guess the reason: this block is based on the source IP** connected to **server A, that is to say, as long as there is an abnormality in the udp traffic on the port of **connecting to server A**, it will connect to the **server A All source addresses of ports** are UDP restricted

Although it sounds confusing, after half a month of testing, it is indeed the case

I’m not sure if it’s the problem of traffic being recognized when hysteria doesn’t open obfs. I think this possibility is very small, and it should be a pass-kill for udp traffic.

* Solution: I will give my solution here, it is still the **same** server A, change another port and open obfs, and then the above phenomenon does not appear

### 11. To be added...
