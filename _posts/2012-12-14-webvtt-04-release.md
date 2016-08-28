---
title: WebVTT 0.4 Release&#58; Midseason Finale
layout: post
date: 2012-12-14 01:30:00
tags: [open-source, osd600]
---
All my favourite TV shows are going on midseason finale, so it is only
appropriate that I should follow. Will there be a huge cliffhanger ending?

Spoiler: no.

### G-Testin
Converting all of my tests to Google Test was a bit trickier than I first
thought. When I initially wrote my tests, they were written to test the
JavaScript validator. I wrote some tests that should pass as valid WebVTT
files, and some that should fail as they were not valid. However, the parser
is not a validator. It is supposed to continue onwards, even if it is fed
an invalid vtt file. Otherwise, someone could simply crash your browser
via libwebvtt by loading a malformed WebVTT file as soon as you loaded
a page. Hax!

I feel like my validator tests still serve a purpose in testing our parser.
They already helped out tons, as my last post outlined. I discovered some
segfaults. Obviously, our library should not segfault when encountering
something unexpected! In this way, the act of loading the webvtt file
into the parser itsself, and not croaking, was an assertion test of sorts.
This is why a few of my tests simply consist of a call to `loadVtt()`.

I look forward to fixing the bugs I found next semester!

Here is the [pull request](https://github.com/humphd/webvtt/pull/91) I
opened.

### gh-pages
The other task I opted to handle was creating a gh-page for our project.
I didn't get around to fleshing it out as much as I would have hoped due
to time constraints, but thanks to nice templates provided by GitHub,
I managed to get something half-decent.

You can see what I have [here](http://dale.io/webvtt/). Don't mind the URL,
it is hosted on GitHub. Also don't mind my username being plastered everywhere
as that is a result of the GitHub Automatic Page Generator.

I've been trying to open a pull request against humph's branch to land this
baby but I've been getting a message about how the two branches have
two completely different histories. I think this may be because the page is
auto generated. Humph may have to copy/paste the raw markdown to his own
Automatic Page Generator... or we can switch to a manual Jekyll build.
I'll try to get to that next semester! *adds to to do list*

### Other Happenings
There isn't much else going on from me for release 0.4. I've been trying to
review pull requests and get the rest of the open pull requests landed. Other then
that, it looks like this semester has finally come to an end.

### OSD600 Reflections
I have to say that I enjoyed OSD600 moreso than any other class I've taken at
Seneca so far. To work on a real project is quite satisfying and strange, a bit
stressful and crazy, but also rewarding and plain ol' fun! We've been working on
something that will end up in the real world and not something you throw away
at the end because it serves no purpose like most projects.

The amount of new tools I've been exposed too is almost bewildering. TravisCI,
autotools, Python ctypes, foreign function interfaces, Google Test, and more
I can't think of because there are so many. My git-fu has improved through
constant use. Skills that cannot be taught, like reading other people's code,
also improved greatly.

Of course, the heart of open source is collaboration. It's funny how many people
were in class that first day, and how fast they dropped out. But those who stayed
proved to be a bunch of pretty cool people who I was glad to work with over the
past semester.

I can't think of a good way to end this post, so I'll just end it now.
