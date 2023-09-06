# Stop updating after `0.3.7` !!!
### cmd client introduction

This project only introduces how to use it in the windows environment, please refer to [here](https://github.com/HyNetwork/hysteria) for other environments.

Because there is no hysteria graphical interface for the time being, I wrote a simple "client?!" with batch processing, which supports automatic proxy change and clear proxy, and it is no problem in actual use.
You can download the latest version from [release](https://github.com/emptysuns/Hi_Hysteria/releases) by yourself.

Other developers are welcome to contribute new UI or plugins.

When the words **Installation Complete** appear, **will automatically print the generated configuration information**, and at the same time, a config.json file will be generated under the **current directory**.

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/result.png)

You can create a new config.json (**must be this name!**) file locally, copy and paste it to the local **conf** folder, or you can directly download the generated file to the local **conf** folder .

Add config.json to the decompression directory of the simple windows cmd client provided in [**release**](https://github.com/emptysuns/Hi_Hysteria/releases).

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/s1.png)

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/s2.png)

What if the local configuration is lost? Use cat to print config.json and then copy:

```
# cat config.json
{
"server": "1.2.3.4:57582",
"protocol": "udp",
"up_mbps": 40,
"down_mbps": 200,
"http": {
"listen": "127.0.0.1:8888",
"timeout" : 300,
"disable_udp": false
},
"socks5": {
"listen": "127.0.0.1:8889",
"timeout": 300,
"disable_udp": false,
"user": "pekora",
"password": "pekopeko"
},
"alpn": "h3",
"acl": "acl/routes. acl",
"mmdb": "acl/Country.mmdb",
"ca": "ca/wechat.com.ca.crt",
"auth_str": "pekora",
"server_name": "wechat.com",
"insecure": false,
"recv_window_conn": 10485760,
"recv_window": 41943040,
"resolver": "119.29.29.29:53",
"retry": 5,
"retry_interval": 3
}

ctrl+c and +v.
```

### Client use

Provides two running methods: running in the background (no sense of cmd window) and running in the foreground (must have a cmd window, but you can view the current log)

**Before starting** Please put config.json in the conf folder!

***************************************************** *****************************

- Method 1: Run in the background (recommended)

Run: double-click back_start.bat

Stop: double-click back_stop.bat

After running back_start.bat, you can press Enter to close this window, no need to keep it.

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/tips.png)

Stop running in the background:

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/back_stop.png)

Batch processing capacity is limited, please understand.
***************************************************** *****************************

- Method 2: Run in the foreground

Run: double-click run.bat

Stop: Enter, or type other non-'n' characters

Open run.bat to run, press the Enter key to stop when running, and type n to continue running

**Type Enter directly to close the client! **

**Type Enter directly to close the client! **

**Type Enter directly to close the client! **

**Remember not to close the cmd window directly! **

**Remember not to close the cmd window directly! **

**Remember not to close the cmd window directly! **

Batch processing capacity is limited, please understand.

<center><font size=2>start</font></center>

![image](https://cloud.iacg.cf/0:/normal/img/hihysteria/mark.png)

<center><font size=2>font-proof/off</font></center>

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/stop.png)

**Tips: In the foreground mode, if you accidentally close the window and cannot access the Internet, run back_stop.bat to clear the proxy and close hysteria. **

***************************************************** *****************************

### The client configuration does not take effect?

As shown in the figure above, the startup is successful, but the proxy is not enabled. Please manually open Settings->Network->Proxy to check whether the configuration takes effect

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/proxy.png)

### Configure autostart

~~No one will not know :)~~

Create a **shortcut** to the back_start.bat(**background mode**) or run.bat(**foreground mode**) file

win+r type

```
shell:startup
```

Open the self-starting directory and copy the shortcut **copy** into it, and it will start automatically next time you boot.

![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/startup.png)
<center><font size=2>The background is used for demonstration here, and the front desk is the same</font></center>
