# hello-SaltStack
My SaltStack states configure 

include:

* nginx
* python
* redis
* nfs-server
* nfs-client
* tomcat
* ...

> Before apply nfs-server or nfs-client , you should perform the following steps

1. Add the following to the pillar file
<pre>
> mine_functions:
>   network.ip_addrs:
>     - eth0
</pre>

2. Signal the minion to refresh the pillar data: `salt '*' saltutil.refresh_pillar`
3. Verify the pillar data: `salt '*' pillar.get mine_functions`
4. Execute the configured functions and send the data back up to the master: `salt '*' mine.update`
5. Verify data from the mine: `salt-run mine.get '*' network.ip_addrs`
