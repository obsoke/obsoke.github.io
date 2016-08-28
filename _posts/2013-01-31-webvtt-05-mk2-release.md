---
title: WebVTT 0.5MKII Release&#58; Bat Country
layout: post
date: 2013-01-31 21:40:00
tags: [open-source, osd700]
---
The past two weeks have been pretty wild. I've gone from knowing absolutely nothing
about how I would go about implementing a DOM spec in a browser to... well, knowing
*slightly* more. Unfortunately, I've procrastinated a bit in writing any blog post.
Instead of writing a long-winded post about everything that has happened, I'll give
the short-n-sweet version for once.

### IDL Hands

I had to do some reading about WebIDL, the interface definition language used to
define DOM interfaces by Mozilla. They have a [great article](https://developer.mozilla.org/en-US/docs/Mozilla/WebIDL_bindings)
on MDN that explains most of what I needed to know to get started. I have this page constantly open in my web browser.

### A Reboot

My development environment has changed since last semester. I've been using [Arch Linux](http://www.archlinux.org)
for the past month. I find myself a lot more productive in an environment that allows for a true tiling manager
such as [Awesome](http://awesome.naquadah.org/). However, that is besides the point. Getting an environment that
can build mozilla-central on Arch Linux is just as simple as it was on OS X. MDN even has Arch-specific instructions
on their excellent [Linux pre-requisite page](https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Linux_Prerequisites).
After getting everything set up and writing my [.mozconfig](https://gist.github.com/4688257), everything built.

### Patch Time

Using commit `5431e9704d7e` off of mozilla-central's GitHub mirror, I was able to split up the pieces of Humph's patch
that I needed to build my code. Of course, I didn't really _need_ to do this. I just misunderstood Humph's instructions.
That's okay! I ended up having quite a few build errors and had to add pieces of the code back in piece by piece. I learned
a bit about interpreting build errors, hunting them down and fixing them. I may have taken the long road, but at least it
had a scenic view! [This Gist](https://gist.github.com/4617234) contains all the patches I ended up applying, including
a few I didn't write myself. I was finally able to build mozilla-central. Yay!

### IDL Implementations

Okay, I swear that was the last pun of this post. Humph and I are going to be taking on the DOM implementation phase
of the WebVTT project. In the mozilla-central tree, the files that concern me can be found in `dom/media`.
Humph has been working on TextTrackCue, and I've been focusing on TextTrack.

Before I started this endeavour, I did a little research on how text tracks are to be used
in the DOM. I found some documentation on [Microsoft's Internet Explorer Developer site](http://msdn.microsoft.com/en-us/library/ie/hh772673(v=vs.85).aspx),
of all places.  The [WHATWG spec page](http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#the-track-element)
also has a pretty detailed explanation of the rules to be implemented in the
DOM implementation. I've been keeping this page open in my browser, and referring back to
it constantly.

From what I understand, a TextTrack class is the representation of a single `&lt;track>` element.
A `&lt;media>` element such as `&lt;audio>` or `&lt;video` can have multiple tracks. One can add
a new track via the DOM API by calling a media element's `addNewTrack()` method. The constructor
from a TextTrack itself seem to take a `kind`, as well as optional `label` and `language` arguments.
There is also a very strange `inBandMetadataTrackDispatchType` property that returns some sort of
metadata that can be used for different purposes (eg: showing recipes during a cooking show). There
is a `mode` enumeration that reveals the current state of the track. There are two TextTrackCueLists:
one with all the cues in the track and one with active cues,  which are cues which has a start time
before the current time and an end time after. In English, it means the cue should be displayed. Obviously,
there are methods to `addCue(TextTrackCue)` and `removeCue(TextTrackCue)`.

So far, I cleaned up both files, formatted them in the Mozilla way, worked on the constructor, fleshed out
a few more methods.. but I feel like at this point, I need to do some research before I can continue. I've done
as much as I can do with my current knowledge. This process is bound to start slow: after all, there is a lot to learn.
By looking at some of Humph's work on the TextTrackCue, as well as making assumptions how things should work, I've managed to get
this far. I do have a few questions before I can move forward though:

* If a property is listed as `readonly` in the WebIDL implementation, do I need to implement it as a `const` in the C++?
* By looking at a TextTrackCueList in its current state, I'm not sure how to interact with it. The DOM spec doesn't say much.
I need to figure out how one uses this object.
* How is the activeCueList maintained?
* In the TextTrack.webidl file, I need to add an enumeration for TextTrackMode. I need to re-read about how to do this. I feel like
everything I read about WebIDL had to be temporarily put into storage while taking in all of this new code in mozilla-central

You can see my work-in-progress patch for this release [right here](https://gist.github.com/4688660). I don't know if there is
quite enough there to warrant uploading it to Mozilla's Bugzilla yet. Next steps: answer above questions, finish TextTrack, move on
to TextTracCueList.
