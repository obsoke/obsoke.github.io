---
layout: post
tags: [open-source, osd600]
date: 2012-11-16 22:55:00
title: WebVTT 0.3&#58; Release? (Hindsight is 20/20)
---
Halfway into nearly every coding project I start, I begin to realize that I've done something wrong. Maybe the way I designed a particular system was flawed,
or I realized that there was a better way of coding some method. I <strike>hope</strike> feel like this this a normal phenomenon when a project covers new ground.
My point is, I feel like I've gone about this Node-FFI stuff all wrong. I started writing bindings for the most complex part of our code, before even testing whether
Node-FFI is in a mature enough state for our needs with a more simple binding. Humph did this with [ctype bindings in Python](https://github.com/humphd/webvtt/blob/ctypes/bindings/python/libwebvtt.py).
He made more progress in a day than all of us did in two weeks... not good!

I've decided to start with the basics, so I created a new branch and started writing some test bindings for [String.h](https://github.com/humphd/webvtt/blob/seneca/include/webvtt/string.h).
Unfortunately, Node-FFI's documentation is scattered between the documentation for the [Documentation for the 'ref' Node module](http://tootallnate.github.com/ref/) and
its own [GitHub Wiki](https://github.com/rbranson/node-ffi/wiki/Node-FFI-Tutorial). I've also been using the Python REPL to replicate Humph's String.h binding code so I can
get a better sense of what works, and what doesn't. It's definitely been helping me but I am now stuck on trying to get webvtt_string_append_utf8() to work. 
I either get an infinite loop or a segmentation fault, so it looks like I'm going to have to suit up and get into debug mode. If I can get that method working tonight
or tomorrow, I figure I'll know enough to hopefully get Node-FFI working with the parser.h methods by Monday. If I can't, then maybe Node-FFI isn't a great
fit for us.

Release 0.3 Stuff:
* [.gitignore Update Pull Request](https://github.com/humphd/webvtt/pull/43)
* [Lastest commit](https://github.com/obsoke/webvtt/commit/a9ab50e030e6e042c12e29e7f1e7782bc477d0cd) in my attempt at getting Node-FFI to work with String.h
