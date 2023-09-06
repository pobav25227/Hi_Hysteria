#### How do I set my latency, up/down speed?

Hysteria is based on the QUIC protocol in the UDP protocol cluster, which has been modified from the violent congestion control algorithm. At the same time, some other functions have been added to facilitate its performance as a "proxy".

During the installation process, you will be asked to set the delay and client speed. Since UDP is connectionless, by default in hihys, the server will not limit the speed of the client, that is, the "infinite" sending/receiving rate of the server/client, the client The only brake on the end is up_mbps/down_mbps.

Therefore, in order to facilitate the performance of hysteria, I suggest that you fill in according to your real expectations. The script will automatically *1.25 for redundancy. If the performance is too low, it will not be able to run to full capacity. If the performance is too high, it will speed up traffic consumption in terms of packet loss rate, or be considered udp flood attack...

* The delay is the RTT delay, the delay obtained by ping can be referred to
* Up/down is filled in truthfully according to the local bandwidth situation, and at the same time, the performance of the landing server must be taken into account. After all, hysteria has more overhead than other proxies, and the CPU is always full, so be careful to violate tos.
