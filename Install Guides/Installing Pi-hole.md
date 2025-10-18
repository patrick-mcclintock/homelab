# Installing Pi-hole

I have primarily used Craft Computing’s video on installing Pi-hole as a guide. The link is [listed here](https://www.youtube.com/watch?v=FnFtWsZ8IP0)
## Creating the VM
There is no hard minimum requirements, since Pi-hole is so light it can run on a Raspberry Pi. These are what I usual choose for my VM settings.
- [ ] Ubuntu Server - Latest stable release
- [ ] 32GB Drive
- [ ] 2 Cores / single socket
- [ ] 2GB of RAM (Can be increased if needed)
- [ ] Network kept at default

## Installing Ubuntu Server

The install is pretty cut and dry, follow the prompts as asked. The only thing that must be installed during the installation is OpenSSH Sever, select yes when prompted. At this point, I also like to set a DHCP reservation to keep this VM at 10.10.10.11 - when installing Pi-hole you can set this address as the static IP on the VM as well.

## Installing Pi-hole

Once Ubuntu is installed, SSH into the VM using PuTTY. Login using the credentials created during installation.

- Install Pi-hole with this bash command
```bash
sudo curl -sSL https://install.pi-hole.net | bash
```

- Keep settings default until is asks for which Upstream DNS provider to use - for now select Google. We will change this later.
- For the block lists, use StevenBlack’s Unified Hosts Lists as the default for now - more can be added later.
- Next it will ask for confirmation to install the Admin Web Interface - select ‘yes’ as well as install the required web server components.
- Select ‘yes’ to enable query logging, then select Anonymous mode
- After this the final installation will begin.
- Once that is complete the console will display the Admin Webpage login password, note this down to be able to login to the Admin Portal.

- The password can be changed using this command in the VM shell;
```shell
pihole -a -p $$password
```

## Installing unbound

- First make sure all the packages are up to date using;
```shell
sudo apt update
```

- Once that finishes, install unbound with;
```shell
sudo apt install unbound -y
```

- In order for unbound to be useful, a configuration file must be created. There is an example one listed on the Pi-hole [website](https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound).
- It will also be listed below - dated 9/14/24
```shell
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
```
- Paste this code block into the pi-hole.conf file by enter this command in the VM shell
```shell
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```

## Configuring Pi-hole

- Once in the Admin Web portal, go to Settings > DNS
- Uncheck the Google DNS servers under IPv4
- Under ‘Upstream DNS Servers’ under ‘Custom 1’ enter in 127.0.0.1#5335. This points Pi-hole to the local unbound instance.
	- Save the changes using the save button on the bottom of the page
- Pi-hole at this point is up and running with the default Block List. More Block Lists can be found [here](https://firebog.net/). I usually run add all the green and bulleted links.