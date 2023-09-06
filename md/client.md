# supported clients

** All clients should fill in ** `recv_window_conn` `recv_window` for connection speed. These two parameters cannot be imported when using one-click link. If you use the generated v2rayN and clash.meta configuration files, don’t worry, passwall and Nekoray, etc. are imported by links and need to be filled in manually.

- [supported clients](#supported clients)
   - [1. Clash.Meta](#1-clashmeta)
     - [Introduction](#Introduction)
     - [Advantages] (#advantages)
     - [use](#use)
   - [2. v2rayN【Recommendation】](#2-v2raynRecommendation)
   - [3. matsuri \[android\]] (#3-matsuri-android)
   - [4. openwrt passwall](#4-openwrt-passwall)
   - [5. openclash] (#5-openclash)
   - [6. NekoRay \[@QIN2DIM\]](#6-nekoray-qin2dim)
     - [6.0 Project Introduction](#60-Project Introduction)
     - [6.1 Download NekoRay] (#61-download-nekoray)
     - [6.2 Download hysteria-core-windows] (#62-download-hysteria-core-windows)
     - [6.3 Configure NekoRay Proxy Core](#63-config-nekoray-proxy-core)
     - [6.4 Import hysteria-node] (#64-import-hysteria-node)
       - [6.4.1 Add from share link or clipboard](#641-Add from share link or clipboard)
       - [6.4.2 Manual editing] (#642-Manual editing)
     - [6.5 Start hysteria-node] (#65-start-hysteria-node)
     - [6.6 \[Optional reading\]Test hysteria node](#66-Optional reading test-hysteria-node)
     - [Reference Materials](#Reference Materials)
   - [7. shadowrocket](#7-shadowrocket)
   - [8. ~~hihy\_cmd~~](#8-hihy_cmd)

## 1. [Clash.Meta](https://github.com/emptysuns/Hi_Hysteria/releases/latest)

### introduce

[clash.meta](https://github.com/MetaCubeX/Clash.Meta/releases/tag/Prerelease-Alpha) inherits all the features of clash, so all the GUIs that clash can use can be used, including openclash, Clash verge, ClashForWindows, etc.

It is recommended to use the [Alpha](https://github.com/MetaCubeX/Clash.Meta/releases/tag/Prerelease-Alpha) branch to synchronize the latest code.

For more clients supporting clash.meta, please refer to [here](https://docs.metacubex.one/used), hihy provides packaged clash.verge, please check it in release, android [view](https:// github.com/MetaCubeX/ClashMetaForAndroid/releases/tag/Prerelease-alpha).

### advantage

It has many necessary functions that the hysteria core cannot perform. for example:

1. `type: url-test` can automatically select nodes based on httping
2. And thanks to the `rule-providers` clash configuration item, users do not need to manually update the shunt rules, it will be updated automatically every time they connect, and it can be completely insensitive.
3. Use doh dot to increase security, and you can also configure nodes for dns separately
4. Fallback test node availability and automatic switching, load balancing
5. All GUI platforms have good support
6. Streaming media split
7.  …

### use

hihy does not support the generation of clash.meta url to import remote configuration files, mainly for security reasons and to prevent node information leakage, **requires the user to copy and paste to the client's own local file to import the configuration**

Here take clash_verge as an example, create a folder at will to save metaHys.yaml:
![image](../imgs/verge1.png)
![image](../imgs/verge2.png)

**test**
![image](../imgs/verge3.png)
![image](../imgs/verge4.png)

clash.meta can be configured at the same time to support vless, ss2022, trojan, etc., but hihy does not currently support it, so I have no good ideas. For more configurations, please refer to [DOC](https://docs.metacubex.one/example/ex1 ).

At present, many excellent features are not supported by the configuration file output by hihy, so look forward to it~d=v=b~

## 2. v2rayN [recommended]

v2rayN already supports hysteria and can automatically identify the type of config when adding custom configurations. hihy is compatible with v2rayN after version 0.3.7. hihy_cmd needs to be withdrawn from the stage. **It will no longer be maintained**.

If you want to experience the latest configuration in time, it is recommended to use this tool.

How will I use it?

You can also directly download my packaged [v2rayN-hysteriaCore](https://github.com/emptysuns/Hi_Hysteria/releases/latest), and ignore the process of configuring v2n below.

**V2rayN upgrade to version 6.0 and above is different from the old version configuration. For versions below 5.39, please refer to the hidden information below. If you choose the latest version 6.0 or above, you can skip it:**

<details>

1. [Click me to download](https://github.com/2dust/v2rayN/releases/latest/download/v2rayN.zip) the latest v2rayN, and unzip it.
2. [Click me to download](https://github.com/apernet/hysteria/releases/) The latest version of Hysteria Core, change the name to `hysteria.exe`, and put it in the root directory of v2rayN.
3. Use the provided [script](https://github.com/emptysuns/Hi_Hysteria/tree/main/acl) to generate the acl file and Country.mmdb file, and create a new folder named `acl in the v2rayN root directory ` and put these two files in this directory.
4. When starting to use, you need to get the config.json configuration file generated by hihy. v2rayN selects this file and double-clicks to select this node. As shown below:

* **Guaranteed to have core and acl files**
   ![image](../imgs/v2ndir.png)
   ![image](../imgs/v2nacldir.png)
* **Configure v2rayN hysteria**
   ![image](../imgs/v2n1.png)
   ![image](../imgs/v2n2.png)
   ![image](../imgs/v2n3.png)
   ![image](../imgs/v2n4.png)
   ![image](../imgs/v2n5.png)
   ![image](../imgs/v2n6.png)
* **Seeing the picture below means that the agent is running normally v2rayN hysteria**
   ![image](../imgs/v2n7.png)
* **The config.json downloaded from the server can be deleted, and v2rayN will automatically create a folder in the directory to save these custom configuration files**
   ![image](../imgs/v2n8.png)

5. **Hello World! **

</details>

**Version 6.0 and above:**
Since v2rayN above version 6.0 will package the hysteria core into `v2rayN-Core\bin\hysteria`, so we don't need to download the core and put it in manually, but we still have to manually download the core to replace it when updating

So we just need to put hysteria's ACL file in the `guiConfigs/acl/` folder, for example:

**If you don’t have these two folders, just create `guiConfigs/` and `guiConfigs/acl/` in the root directory of v2rayN**

* [routes.acl](https://github.com/emptysuns/Hi_Hysteria/raw/main/acl/routes.acl) #hysteria distribution rules
* [Country.mmdb](https://github.com/emptysuns/Hi_Hysteria/raw/main/acl/Country.mmdb) #GeoIP file

   ![img](../imgs/v2n6%2B.png)

   Of course, the ACL has been packaged in the release, otherwise it will report an error that there is no ACL file and it will not start normally.

## 3. [matsuri](https://github.com/MatsuriDayo/Matsuri/releases) / [nekobox](https://github.com/MatsuriDayo/NekoBoxForAndroid/releases)[android]

   Sagernet has not been updated for a long time, ~~It is recommended to replace its magic branch Matsuri~~, it is recommended to replace its magic branch nekobox, by [https://matsuridayo.github.io/](https://matsuridayo.github .io/) maintenance

   Matsuri will no longer launch major updates, **recommended to update nekobox based on sing-box**

   [https://github.com/MatsuriDayo/NekoBoxForAndroid/releases](https://github.com/MatsuriDayo/NekoBoxForAndroid/releases)

   It can be imported through a one-click link, but the buffer cannot be imported. You need to manually enter the `recv_window_conn` `recv_window` parameter

   ~~Install [hysteria-plugin](https://github.com/MatsuriDayo/plugins/releases) and **allow the plugin to be started by other applications**, otherwise the prompt will fail to start~~

   tips: nekobox supports direct clipboard import of hysteria's json configuration text can be automatically configured

## 4. openwrt passwall

It can only be added when compiling the firmware. Please update the op to the latest version to support hysteria. See the corresponding config.json below
![image](../imgs/passwall.png)

Support one-click import, but also need to manually fill in the buffer configuration and port jump address

## 5. openclash

To be supplemented or please submit pr

## 6. NekoRay [[@QIN2DIM](https://github.com/QIN2DIM)]

**Table of contents**

### 6.0 Project Introduction

[NekoRay](https://github.com/MatsuriDayo/nekoray) —— Qt/C++-based cross-platform agent configuration manager, is an open source project still in the growth stage. NekoRay supports the parsing of the `hysteria://` protocol header before V2rayN, and players can import hysteria nodes in batches through the node sharing link. In addition, NekoRay cleverly implements the action integration interaction of "node activation + node testing", which can be based onManage and test hysteria nodes as a group without manually configuring socks5 listeners.

NekoRay currently supports Windows / Linux amd64. The following takes NekoRay v1.5 Windows as an example to introduce the quick entry steps of the client.

### 6.1 Download NekoRay

Go to [Releases · MatsuriDayo/nekoray](https://github.com/MatsuriDayo/nekoray/releases) and download the latest version of NekoRay for Windows. No installation required, out of the box. Here it is assumed that the decompression directory is `C:\\nekoray`, and the main program path is `C:\\nekoray\\nekoray.exe`.

### 6.2 Download hysteria-core-windows

Go to [Releases · HyNetwork/hysteria](https://github.com/HyNetwork/hysteria/releases), download the latest version of `hysteria-windows-amd64.exe`, and place it in the decompressed NekoRay configuration directory, For example: `C:\\nekoray\\config\\hysteria-windows-amd64.exe` (this is optional, but **config** is the default startup path of the core interface, so you can find files in this way).

### 6.3 Configure NekoRay Proxy Core

Enter the "Preferences" "Basic Settings" "Core" interface in turn, select the absolute path of **hysteria-core**, that is, the absolute path of the newly downloaded `hysteria-windows-amd64.exe` file.

After selecting, switch to the "Basic Settings - General" interface, **enable the HTTP listening port**. Other settings remain default, click OK to save the settings. The relevant steps are shown in the figure below:

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187100719-47d2986b-6ef4-4996-8561-d7f17b491747.png"/>
</p>

### 6.4 Import hysteria node

#### 6.4.1 Add from share link or clipboard

NekoRay supports the parsing of the `hysteria://` protocol header, and you can directly paste the subscription link in to automatically obtain the configuration information of the node, as shown in the following figure:

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187100758-65941f04-b87d-4cbd-80f5-800c157eb1bc.png"/>
</p>

#### 6.4.2 Manual editing

The comments of related configurations and the generated panel preview results are shown in the figure below:

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187100799-9b7a7cdd-70c8-4443-ba22-928224e86ae2.png"/>
</p>

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187100811-f5ff59c4-27f6-44f4-b0c2-587da662bd09.png"/>
</p>

There are placeholders called `replacement string`, namely `%mapping_port%` and `%socks_port%`, which do not need to be modified, just keep the default.

### 6.5 Start hysteria node

When using it for the first time, select the target node and click "Program - System Agent - Start System Agent" in sequence. When the console starts to continuously output log information from hysteria-core, it means that the node starts successfully, and you can visit sites such as Google or Youtube to verify the behavior.

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187100876-b8afceba-1af9-4012-a20d-b6ab3dfc32ae.png"/>
</p>

It is worth mentioning that NekoRay's <System Agent Startup> and <Agent Core Operation> businesses are separated, that is, the effect of pressing Enter on the node is to start/restart the agent core, only by checking the "Start System Agent" Only then can it connect to the Internet, which is similar to V2rayN.

### 6.6 [Optional] Testing hysteria nodes

After properly configuring the pre-proxy options, you can integrate "node activation + node testing" into one action, which is more elegant than V2rayN's current (~v5.32) solution.

If you follow the steps introduced in this document, you only need to click "Server-Current Group" in the default group state to call up the interface of the test control, as shown in the figure below:

<p align="center">
<img width="30%" src="https://user-images.githubusercontent.com/62018067/187101054-ae6fc4d9-b474-4dde-887d-7e604ef40618.png"/>
</p>

NekoRay integrates some mainstream testing tools, just run the "full test" directly. The test includes the following four items (click to jump to the source code):

<div align="center">
<table style="border: 2px #000000 groove">
<thead>
<tr>
<th style="border: 2px #000000 groove">Test project</th>
<th style="border: 2px #000000 groove">Introduction</th>
</tr>
</thead>
<tbody>
<tr>
<td style="border: 2px #000000 groove"><a href="https://github.com/MatsuriDayo/nekoray/blob/4ed46c10feef17831398d7daf5829e01b446d3f5/go/grpc_core.go#L204">Latency latency test</a> </td>
<td style="border: 2px #000000 groove"></td>
</tr>
<tr>
<td style="border: 2px #000000 groove"><a href="https://github.com/MatsuriDayo/nekoray/blob/4ed46c10feef17831398d7daf5829e01b446d3f5/go/grpc_core.go#L247">Download speed test</a> </td>
<td style="border: 2px #000000 groove">Use a proxy to download a 10MiB file and calculate the download speed. </td>
</tr>
<tr>
<td style="border: 2px #000000 groove">
         <a href="https://github.com/MatsuriDayo/nekoray/blob/4ed46c10feef17831398d7daf5829e01b446d3f5/go/grpc_core.go#L216">Entry IP</a>,
         <a href="https://github.com/MatsuriDayo/nekoray/blob/4ed46c10feef17831398d7daf5829e01b446d3f5/go/grpc_core.go#L229">Exit IP</a>
       </td>
<td style="border: 2px #000000 groove"></td>
</tr>
<tr>
<td style="border: 2px #000000 groove"><a href="https://github.com/MatsuriDayo/nekoray/blob/4ed46c10feef17831398d7daf5829e01b446d3f5/go/grpc_core.go#L263">NAT type</a>< /td>
<td style="border: 2px #000000 groove"></td>
</tr>
</tbody>
</table>
</div>

The output of the test is shown in the figure below:

<p align="center">
<img width="75%" src="https://user-images.githubusercontent.com/62018067/187101128-8bbc47ee-2027-4fc5-90a5-43eb08209a1c.png"/>
</p>

We use the simplest QUIC direct connection scheme in the classic hysteria proxy topology, that is, the entry address In and the exit address Out are the same, and their values are the real IP of your proxy server.

It should be noted that hysteria is a communication protocol implemented based on quic-go, and TCPing tests are not available.

### References

1. [Nekoray-Configuration - Matsuri &amp; NekoRay](https://matsuridayo.github.io/n-configuration/)

## 7. shadowrocket

No iOS, please submit pr item

## 8. [~~hihy_cmd~~](cmd.md)

**Stop updating**
