---
layout: post
tags: [open-source, osd600]
title: Moving on with WebVTT Release 0.2
date: 2012-10-12 14:10:00
---
Work on WebVTT Release 0.2 is now underway! Huzzah! We have about two and a half weeks to complete our assigned tasks. As much fun as writing the test suite was, I am looking forward to get into the more meaty aspects of the project. Some of us are working on finishing [rillian's C-based parser](https://github.com/rillian/webvtt/blob/master/webvtt.c). Some of us are working on a WebVTT parser written in Mozilla's [Rust](http://www.rust-lang.org/) language, which I'm interested in seeing. Some of us are going to try our test suite against the WebKit implementation to check their parser and our tests for bugs. Some of us are writing fuzz tests, and some are documenting. Jordan and myself are going to be working on fixing bugs in the [JavaScript WebVTT parser](https://github.com/daliuss/node-webvtt/blob/master/lib/parser.js). The JavaScript parser is used in the [online WebVTT validator](http://quuz.org/webvtt/) and David Humphrey's [node-based WebVTT parser](https://github.com/humphd/node-webvtt). There are a few bugs in the JS parser causing some tests to fail when they should be passing. My job will be much easier thanks to [some awesome test analysis](https://github.com/humphd/webvtt/pull/32#issuecomment-9324437) by the machine-like Kyle Barnhart (thanks dude)!

I found it a bit amusing that so many people wanted to work on the C parser. There are 3 groups of 2 developing the C parser in parallel. I would have liked to work on it as well. I enjoy working in C; it's a fantastic language even if it feels a more 'manual' than higher-level languages. However, I believe that JavaScript is the future, so improving my JS skills is always desirable.

If time permits, I'd also like to get started on an Python implementation of the parser. I love working in Python, and since Python can run in many different environments, it may be beneficial to have. Plus the more implementations, the better!

Onwards and upwards!
