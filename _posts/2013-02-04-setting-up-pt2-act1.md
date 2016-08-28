---
title: Setting up a BigBlueButton Dev Envrionment, Part 2, Act 1, Manchester 0
layout: post
date: 2013-02-04 14:47:00
tags: [open-source, cdot]
---
Continuing on my journey to reach a development environment fit to work on BBB's HTML5 client,
I reached a roadblock on my very next step. When attempting to download bigbluebutton-web's
dependencies with `gradle resolveDeps`, I was getting a build error. Some of the dependencies
listed no longer existed in the server that gradle grabs the packages from. After a bit of
searching on the mailing lists, I discovered that someone else [was having the same issue](https://groups.google.com/forum/#!topic/bigbluebutton-dev/0TV21eK_p6o/discussion).
Applying the fix suggested in the thread solved my issues. I'm glad that the mailing lists used by BBB
are arhived, as it makes it easier to find problems and solutions that have occurred in the past.

At this point, I've completed all the prerequisite tasks listed in the HTML5 dev environment setup
article: I upgraded my dev environment to 0.81, as well as built the BBB Flash client, web API and red5
applications. Now I can finally start setting up my HTML5 dev environment!

Following the instructions on [the HTML5 dev environment setup article](http://code.google.com/p/bigbluebutton/wiki/HTML5DevEnvironmentSetup)
was fairly straightforward. However, once I tried to log onto the HTML5 client,
I was once again faced with an issue. Hey, if this was too easy, then I wouldn't have learned anything!
My issue was that once I hit the HTML5 client's landing page, a dropdown box that is supposed to be populated
with meeting rooms to join was empty! The exact same issue was reported earlier [on the bigbluebutton-dev mailing group](https://groups.google.com/d/topic/bigbluebutton-dev/zZLKGGewKSc/discussion).

One of the recommended actions was to check whether the meeting was being created within our Redis database.
I've never used Redis before, although I know it's an in-memory data store.
Anyway, [here is the output](http://hastebin.com/nomevahahi.md) of checking the keys in my Redis database at different points
in starting the BBB HTML5 client stack.
The first query was made right after starting bbb-web and the Node HTML5 client.
The second query was made after joining a meeting with the Flash client.
The last query was made after connecting to the HTML5 client's landing page.
It seems to be that the meeting was being created in the Redis database, so there must be another issue here.

One of the BBB developers, Marco, sent me an email earlier in the day offering to help if
I was stuck so I took him up on his offer. We connected on Skype and talked about possible solutions.
I had two issues. My nginx config was again causing issues. It seems the config I used earlier to fix that pesky
500 Internal Server Error was causing the API and HTML5 client to have a hard time finding each other. I switched back to
the old nginx config and was again faced with the 500 page after trying to log into the Flash client. Marco helped me solve
an issue the grails bbb-web app was giving (Something about a missing property about .swf file sizes). Adding that property
into the properties file and restarting nginx and bbb-web a few times seemed to fix both the 500 error. Not only that but now
the HTML5 client drop down box. I could now log into the HTML5 client.. Yay!

It took a while but it looks like I finally have a development environment to call my own. Now, it is time to start hacking!
