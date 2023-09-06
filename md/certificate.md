#### hysteria self-signed certificate

**Self-signed certificates are no longer recommended, GFW will randomly block self-signed certificate packets recently (this prompt does not disappear, indicating that the blocking is still there)**

There is a risk of MIMT (Man-in-the-middle attack, man-in-the-middle attack) when **allowing insecure connections** when self-signed certificates. Now the script allows unsafe connections by default (~~I think the probability of being attacked is extremely small anyway, judge for yourself~~

For the v2rayN client, when using a self-signed certificate and wanting to be as secure as a normal certificate, please refer to:

1. Manually copy the server self-signed CA `/etc/hihy/result/wechat.com.ca.crt` to v2rayN-hysteria's `ca/` folder (if there is no such folder, create a new one)
2. Modify config.json `"insecure": true` to `false`
3. Add `ca` option `"ca": "ca/wechat.com.ca.crt",` in config.json (modified according to self-signed domain name)
4. Rerun
