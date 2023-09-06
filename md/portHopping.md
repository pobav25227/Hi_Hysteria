#### Introduction to [Port Hopping/Multiple Ports] (Port Hopping)

**During BETA testing, if you have any questions, please send an issue to ask**

Hysteria introduced the Port Hopping function in version 1.3.0, which is intended to improve the user feedback of **planting flowers and congratulations** on the problem that long-term single-port UDP connections are easily blocked by operators/QoS.

After testing, the effect is **very obvious, but ** is ** only supported by UDP protocol, other protocols ** do not support ** open

In view of the large impact of this change on the configuration, **Many clients such as nekoray/clash_meta/passwall do not support this function very well**, currently only use V2rayN

**The way to run directly using hysteria core** is supported, but both ends (server and client) need to be upgraded

**Currently unable to import via one-click link**

And this multi-port monitoring function is not that the server hysteria directly monitors the port, but forwards some ports to the listening port through iptables NAT.

You can see from the above information that this function is currently very **new**, and there is no good adaptation in various places. Hihy is currently in the groping stage for the adaptation of this function. If you have any good suggestions, please post in issue propose

Refer to https://hysteria.network/docs/port-hopping/
