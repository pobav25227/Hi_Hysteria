#### Restricted UDP service provider demining list [2022/03/21 update]

The reason is that a small number of IDCs are afraid of being suspected of life by D, so they can't come up with the next article. Please rest assured that most of the hysteria service providers are performing normally**. And the list below is the only "conviction" that is not available, please self-test whether it is normal or not (it can be used if it is not in the list), it is for reference only:

The log shows `[error:timeout: no recent network activity] Failed to initialize client`

* digitalocean: sometimes available, sometimes not available, the firewall rules are unfathomable, and its floating ip has stricter rules.
* vultr: Consistent with DigitalOcean
* virmach: Telecom is available in the same area, mobile is not available.
* aws: When you use the udp mode such as udp/wechat-video mode with the ec2 instance, it will be considered by aws as an external udp attack and you will receive a warning email.
* ovh: udp mode is available, but it will cut off the flow from time to time, faketcp is no problem
* RackNerd: Many people reported that its Los Angeles area cannot use udp/wechat-video and other udp-type protocols
