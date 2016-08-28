---
layout: post
tags: [open-source, osd600]
title: Progress on Tests, Debates on Comments
date: 2012-09-26 23:30:00
---

### Progress on WebVTT Cue Time Conformance Tests
I just finished writing up a bunch of cue timer tests for the WebVTT test suite we are building in OSD600. My group and I have been documenting our progress on our [wiki page](http://zenit.senecac.on.ca/wiki/index.php/Cue_Times), and committing our tests to [my fork](https://github.com/daliuss/webvtt/tree/master/test/spec) of [rillian's webvtt](https://github.com/rillian/webvtt) repo on GitHub. I was worried that I wouldn't be able to think of any tests to write, but reading all the sections on timestamp syntax in the [WebVTT draft spec](http://dev.w3.org/html5/webvtt/) a few times helped generate a few good ones.

Our group has a pretty good review system in place, in my humble opinion. We add our tests to a table in the wiki as they are done. We have a column in our table for Peer Review, which another team member will fill out once they have 'signed off' on a test. This way, everything keeps track of itself in a way, and it is easy to see what is left to be done or what tests still need peer review. The use of wikis as a collaborative tool is awesome!

### Should comments be allowed in WebVTT files?
Yesterday, I popped onto IRC as an interested discuss was taking place (or had just recently ended). People were talking about comments in WebVTT files. I asked the channel whether they believed comments are appropriate for WebVTT files. Personally, I don't think they are. As someone mentioned in the IRC channel, it would be a benefit mostly only to people writing tests for the WebVTT parser. I can't think of a normal use case where comments would be needed in a subtitle file. I've searched online for whether any other video caption files, like the SRT format, have comment support but I couldn't find any relevant information.

Humph made an interesting point as well: people will most likely be using tools to generate WebVTT files. Will an end user creating a WebVTT file ever see the syntax, or will they just be using a UI to generate it? If the latter, comments would be pretty useless.

Maybe I'm just not seeing some obvious use case where comments would be beneficial to anyone but people writing tests. I'm interesting in hearing what others think on the matter, so please leave a comment with your opinion on this matter!
