---
title: Setting up a BigBlueButton Dev Environment, Part 1
layout: post
date: 2013-01-31 12:40:00
tags: [open-source, cdot]
---
BigBlueButton has a [Linux-based virtual machine image](http://code.google.com/p/bigbluebutton/wiki/BigBlueButtonVM)
that is used to quickly get a BigBlueButton server and development environment up and running without spending
hours configuring tools and applications. By providing a ready-to-go stack, BigBlueButton developers
have somewhat of a baseline to not only develop against, but of what a stable BigBlueButton stack looks like.
I imagine this makes solving issues a bit easier as everyone would have a baseline to compare their environment
against. Anywho, I have joined the ranks of those consuming this VM.
My end goal is to have the VM set up to start contributing to the development of the HTML client.

First, I made sure I completed all the instructions in getting the virtual machine initially set up. This was fairly
straightforward, although I wasn't able to get port forwarding from my Linux host to VirtualBox working. I ended up
just downloading VMWare Player, where the port forwarding seemed to work fine.
Next, since the HTML5 client requires the latest development version of BBB (0.81),
I had to upgrade the VM which is shipped with the currently-stable 0.8. The instructions to
do that can be found on the [InstallationUbuntu](http://code.google.com/p/bigbluebutton/wiki/081InstallationUbuntu) page.
These instructions were also straight-forward and I completed all the tasks with no problems.

Now that the all the internal tools have been updated, we are ready to get the source and build
some of the applications in the stack. A guide to do that can be found on the [Developing BBB](http://code.google.com/p/bigbluebutton/wiki/DevelopingBBB)
wiki page. The instructions on this page have to be a bit altered as we are developing for the HTML5 client. Instead of checking out the master
branch of BigBlueButton's git repository, we will check out the html5-bridge branch, where the HTML5 client lives. The instructions for the HTML5
client also recommends to build and run the Flash client, bigbluebutton-web and some other components.

Unfortunately, this is where I hit my first real roadblock. Once I've compiled the bbb-client, I tried to connect to a demo meeting. I was greeted by a very
scary Internal Server Error 500 page. Apparently, I got a NullPointerException error.

I did a little digging and found that I was not the only one to have said error. [This post](https://groups.google.com/forum/?fromgroups=#!topic/bigbluebutton-setup/60t-iMC6fEI)
describes the same problem, with a possible solution: use port 80! However, upon running `sudo bbb-conf --check`, I was presented with the following:
{% highlight bash %}
/etc/nginx/sites-available/bigbluebutton (nginx)
  server name: MY_IP
  port: 80
  bbb-client dir: /home/firstuser/dev/bigbluebutton/bigbluebutton-client
{% endhighlight %}

Weird. I am already on port 80. However, I noticed a few more potential problems listed further below:
{% highlight bash %}
# Warning: nginx is not serving BigBlueButton's web application
# from port 8080
#
# (This is OK if you have setup a development environment.) 

# Warning: There is no application server listening to port 8888.

# Error: Could not connect to the configured hostname/IP address
#
#    http://MY_IP/
#
# If your BigBlueButton server is behind a firewall, see FAQ:
#
#   http://code.google.com/p/bigbluebutton/wiki/FAQ
#
# (See entry for setting up BigBlueButton behind a firewall.)

# Warning: The value (192.168.0.166) for playback_host in
#
#    /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml
#
# does not match the local IP address (MY_IP).
{% endhighlight %}

We should be able to ignore the first warning: We know we are on port 80, and on a development environment... right?
Well, not so fast. On the 500 error page that loads up, the header list says that the host address is 127.0.0.1:8080.
Well... 80 !== 8080. So what's going on here? I am not quite sure yet.
Running bbb-conf --check has revealed other potential problems as well. The single error listed is a bit confusing though:
"Could not connect to the configured hostname/IP address. Could this be related to not being able to connect to the client?
I suspect it may.
The last warning, that the value of playback_host doesn't match my IP, could also be a problem. That seems
like an easy enough fix though.

Chad just arrived in the CDOT space and let me know that he saw my pleas for help on IRC, and may have an answer.
The [FAQ on the BBB wiki](http://code.google.com/p/bigbluebutton/wiki/FAQ#Using_the_API_examples_I_get_an_java.lang._NullPointerException)
contains a question & answer that addresses this very problem. I guess this is why it is always important to RTFM! I shall now try this fix!
*crosses fingers*
