---
title: Setting up a BigBlueButton Dev Environment, Part 1, Act 2
layout: post
date: 2013-02-01 11:23:00
tags: [open-source, cdot]
---
Thanks to Chad's help, I was able to resolve that 500 Internal Server Error problem
I was having yesterday. Apparently it was due to the nginx configuration I was using.
On the server VM, I navigated to `/etc/bigbluebutton/nginx`. There are three files
that concern us. `web.nginx` is the nginx configuration BBB uses. It is usually a
symlink to one of two files: `web` or `web_dev`. I had my `web.nginx` pointed to
`web_dev` rather than `web`, which was giving me issues. After running a quick command
to fix, everything was once again right in the world:

`$ ln -sf /etc/bigbluebutton/nginx/web /etc/bigbluebutton/nginx/web.nginx`

`web_dev` had its port set to 8888, instead of 8080. And everything is peachy once again!
