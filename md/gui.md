#### Borrow other GUIs that support Socks5 to get a graphical interface

hysteria supports socks5 to be pushed into the stack, and now almost all mainstream proxy software UIs support importing socks5 links for use, such as v2rayN, clash, qv2ray, winxray and so on.


In fact, this method is very clumsy. I thought that a graphical interface serving hysteria would be born soon, so when I wrote the cmd client, it was designed to survive this transitional period, and I didn't pay much attention to its usability.

As a result, there are many problems to be solved (not humanized, it is inconvenient to switch between multiple configuration files, etc.), but to implement the basic spirit of "** as long as it can be used", the pigeons are now, and they will be pigeonholed indefinitely in the future go down~~~

**I didn't expect it to last for so long... UI leaders are working hard**.


So here we can "doves occupy the magpie's nest" to seize their original "site" of the original graphical interface and make them serve hysteria.

Here we use **v2rayN + hihysteria_cmd** as an example, and the same is true for others (see [**here**](https://github.com/emptysuns/Hi_Hysteria/blob/main/md/cmd.md for the introduction of hihysteria cmd) )):


1. Use the hihysteria cmd client to test that `run.bat` runs successfully, and hysteria can be used as a proxy normally.
![image](https://cloud.iacg.cf/0:/normal/img/hihysteria/mark.png)

2. Press Enter to close `foreground running mode`, double-click `back_start.bat` to start background running mode.

3. Start V2rayN.

     It should be noted here that ** is to run the back_start.bat of cmd first, and then open V2rayN**, because
     V2rayN will modify the system proxy, and so will `back_start.bat`. If it is started after V2rayN, V2rayN will be replaced by the address modified by the cmd client, and it will not be able to take over the http proxy of the system. Note that the port address in the following figure is Taken over by V2rayN, not hysteria's `8888`.

     ![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/proxy.png)

     If it is `8888`, click `Automatic Configuration System Proxy` again.

     ![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/changeProxy.png)

    
     After all, this is an alternative way of playing, and it is not just optimized for this. If you want to use "**Dove Occupying Magpie's Nest**" for a long time, you can modify `back_start.sh` and `back_stop.sh` by yourself, delete All the modified registry entries below will prevent the cmd client from automatically configuring the system http proxy.
     ```
         REG add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
         REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoDetect /t REG_DWORD /f /D 0
         REG add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "127.0.0.1:8888" /f
         REG add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.* ;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168 .*" /f
     ```
4. Import the socks5 link as shown below:
   
    ![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/s5.png)
5. Done, verify the result
   
    ![image](https://raw.githubusercontent.com/emptysuns/Hi_Hysteria/main/imgs/v2rayN.png)


##### end
The UI of other agents such as Clash will support S5 links, so I won’t introduce them here, have fun~
