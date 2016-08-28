---
title: BBB HTML5 Development Environment Walk-through
layout: post
date: 2013-03-13 13:50:00
tags: [open-source, cdot]
---
One of the issues I've had so far while working on BigBlueButton is getting
my development environment set up correctly. In order to help future BBB HTML5
devs get off to an easier start when trying to contribute, I've decided to write
a mini-guide with the steps **I** took to get my development environment set up
correctly.

### Step One: Downloading the BBB VM

Full instructions on this subject can be found [here](https://code.google.com/p/bigbluebutton/wiki/BigBlueButtonVM)

1. Download the VM image and open it in VMWare Player / Workstation
2. Under your VM settings, make sure that the internet connection mode is set to 'Bridged'. If you don't have a DHCP
server on your network, I highly recommend buying a cheap wired router and putting your development computer behind it.
DHCP is required for Bridged networking mode to work, and it is much easier to get a development environment setup
when using Bridged networking.
3. Start the BBB Ubuntu VM. If your network settings are correct, it should start updating the VM automatically. Step
away and grab a coffee; this may take a while.
4. Once the update is complete, open a web browser on your host OS and type in the IP address of your VM. The BBB landing
page should show up. If it doesn't, please read the Troubleshooting section in the BBB VM article linked above, or ask
in the forums for assistance.

### Step Two: Upgrading the VM to 0.81

Full instructions on this subject can be found [here](https://code.google.com/p/bigbluebutton/wiki/081InstallationUbuntu)

The instructions listed above are pretty accurate. The only interesting things I discovered when moving through these are:

1. Under `Install Ruby`, it is unnecessary to install dependencies. They are already installed on the VM.

2. I had some errors while trying to get `rubygem` to work. Uninstalling the built-in version and re-installing
seemed to do the trick. **(EDIT: 2013/04/17: If you are upgrading from an older version of BBB, just skip all the Ruby-related steps.
You should already have the required version installed.)**

Once you've finished upgrading your VM from 0.80 to 0.81, move on to the next step.

### Step Three: Setting up the standard development environment

Full instructions on this subject can be found [here](https://code.google.com/p/bigbluebutton/wiki/DevelopingBBB)

The instructions for this step can be found at the link above.

* Setup a Development Environment - Setting up the development tools
* Setup a Development Environment - Checking out the source: Under this step, instead of running the command `git checkout -b my-bbb-branch v0.8` to
check out the proper branch, use `git checkout -b html5-bridge origin/html5-bridge`
* Client Development - Setting up the client
* Client Development - Build the client
* Developing BBB-Web
* Developing the Red5 Applications - Developing BBB Apps

These should be the only steps required to get the HTML5 client running.

### Step Four: Setting up the HTML5 development environment

Full instructions on this subject can be found [here](https://code.google.com/p/bigbluebutton/wiki/HTML5DevEnvironmentSetup)

Follow the instructions at the link above under **HTML5 Bridge component - Installation**.

At this point, you should have an environment setup and ready for you to hack away on!

### Step Five: Running the development environment

Now it's time to get BBB up and running. Note that every time you reboot the virtual machine, you're going to have to repeat
this process.

I find this process easiest when running a terminal multiplexer such as `screen` or `tmux` once you have SSH'd into the virtual
machine. That way, you only have one terminal window open for a variety of tasks. You can perform each of the above tasks in its
own newly-created window or pane. Finally, you can detach your session and reattach later on, removing the need to repeat the
following process over and over again.

1: Start BBB-Web:
{% highlight sh %}
$ cd /home/firstuser/dev/bigbluebutton/bigbluebutton-web/
$ grails -Dserver.port=8888 run-app
{% endhighlight %}
2: Start BBB-Apps
{% highlight sh %}
$ sudo /etc/init.d/red5 stop
$ cd /usr/share/red5/
$ sudo -u red5 ./red5.sh
{% endhighlight %}
3: Start the HTML5 app
{% highlight sh %}
$ redis-cli flushdb
$ cd ~/dev/bigbluebutton/labs/bbb-html5-client
$ node app.js
{% endhighlight %}

And that's that!
