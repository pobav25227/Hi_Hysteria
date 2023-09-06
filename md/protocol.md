### Introduction to each protocol

#### 1. udp

It can be identified as QUIC traffic, and it is best to use it directly.

After version 0.2.5 of the script, the `obfs` option is no longer added by default. Because the obfuscation overhead is too large, the CPU performance will become the speed bottleneck.

Moreover, the operator will not only limit the speed of QUIC transmission, and the speed has not been limited during the long-term test process, so the `obfs` support has been canceled.

#### 2. faketcp

hysteria v0.9.1 began to support faketcp, which disguises hysteria's UDP transmission process as TCP, which can avoid the speed limit and blocking of UDP by the QoS equipment of operators and "professional" IDC service providers.

At present, the faketcp mode client only supports the use of root users in linux-like systems including Android, and **windows cannot be used** (but it can be replaced by fake tcp with udp2raw).

So my suggestion is:

**Do not enable it when pursuing proxy performance**. When the download speed has been limited to a very, very low rate such as 128kB/s, you confirm that UDP is limited and then reinstall and enable it. It will not "speed up", but will increase the CPU overhead, causing hysteria "slow down".

**Pursue stability and can prepare root permission to use the environment**. If you can open faketcp, open it.

#### 3. wechat-video

Voice and video calls disguised as wechat may bypass the targeted speed limit of udp by a small number of domestic operators? To be confirmed.
