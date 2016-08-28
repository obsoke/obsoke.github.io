---
title: Port Forwarding on Arch Linux and VMPlayer with a NAT connection
layout: post
date: 2013-02-26 13:30:00
tags: [open-source, cdot]
---
Apparently, there is another nasty snow storm coming to Toronto tomorrow, so I decided
to prepare for the possibility that I may need to work from home. While I've had SSH working
fine, I wasn't able to access BigBlueButton clients running on the Ubuntu VM from outside
of the CDOT network. So I decided to do a bit of research to get my ports open.

I used iptables as my packet forwarding tool and that is what these specific instructions are written for.
However, it should be fairly simple to adapt these instructions for the tool of your choice.

### Step 1: Open Ports on Arch Linux

Follow the instructions on the [iptables wiki page](https://wiki.archlinux.org/index.php/Iptables)
to install iptables and enable it with systemd. iptables will fail to load if a default rules
file does not exist at the location pointed at by `IPTABLES_CONF`. This variable is defined in
`/etc/conf.d/iptables`, the default location pointed at being `/etc/iptables/iptables.rules`. There are
example files in `/etc/iptables` to use as templates if you don't want to start fresh.

In `/etc/sysctl.conf`, make sure the following options are set:

* net.ipv4.ip_forward=1
* net.ipv6.conf.default.forwarding=1
* net.ipv6.conf.all.forwarding=1

With iptables running correctly, we can now setup some forwarding rules. At a command line, use
the following command to open a TCP port of your choosing on your host machine:

```$ iptables -A INPUT -p tcp --dport <PORT_NUMBER> -j ACCEPT```

Where `<PORT_NUMBER>` is the port number you wish to forward to the virtual machine. Add as many rules as
you wish. If you wanted to close a port instead of open one, you can replace the keyword `ACCEPT` at the end
of the command with `DROP`.

While we told iptables what new port forwarding rules we want to use, we haven't yet saved these rules to file.
We can do this by running:

```$ iptables-save > /etc/iptables/iptables.rules```

If you don't want to overwrite any current rules, you should use `>>` rather than `>` to append to the end
of the rules file.

Now we need to restart iptables:

`$ systemctl restart iptables`

At this point, we should be able to access the open ports from outside of the network. Now we need to set up
VMWare Player to accept incoming connections from these ports.

### Step 2: Port Forward with VMWare Player

At CDOT, we don't use DHCP for automatic IP assignment, so I cannot use the bridged networking option in VMWare Player.
I'm using the NAT networking option, which is set to the virtual networking device `vmnet8` by default. The settings for
this virtual interface can be found in `/etc/vmware/vmnet8/nat/nat.conf`. Open this file in your favourite editor and look
for the section titled `[incomingtcp]`. Each line under this section declares an individual port forwarding rule. Here is an
example of one I'm using to forward HTTP traffic from the host to the VM:

`80 = <VM-IP>:80`

From left to right, the above reads: forward incoming traffic to the host port 80 to the VM IP at port 80.

At this point. you should be able to access your forwarded ports from outside of the network. Huzzah!

