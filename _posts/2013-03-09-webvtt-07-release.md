---
title: WebVTT 0.7 Release&#58; The Other Side of the Review
layout: post
date: 2013-03-09 16:45:00
tags: [open-source, osd700]
---
During the last few weeks, I've been working through the huge and detailed review of my patch
written by Mozillian Ms2ger (thanks again!).  I've gone from a dog wearing a tie at a computer
with no clue as to what he was doing to an owl wearing glasses and a graduation cap.
I think that is an upgrade.

After a few iterations, many questions asked, and much head scratching, I finally
submitted the 4th version of my patch Wednesday night.  This patch contained the
fixes requested by Ms2ger. The Bugzilla thread, along with the patches I submitted
and discussions had about it, can be found [here](https://bugzilla.mozilla.org/show_bug.cgi?id=833385).
My GitHub repo / branch containing all my work so far can be found
[here](https://github.com/obsoke/mozilla-central/tree/new-dev).

Now for a look at the victories and defeats I've had over the past few weeks,
how I overcame said defeats, and what's in store for the future.

#### Victories

### Easy Fixes

Quite a bit of the review involved changing variable names, spacing and positions of
the dereference operator `*`. I get why this is needed: a code base is much
easier to read through if it looks as if all the code was written by a single person.
This is done by enforcing certain guidelines, like method arguments following the
naming convention `aFoo` and making sure the tabs and spacing of all the arguments
are consistent. The `.` (repeat) and `n` (find next) operators in Vim makes repeating
changes like this much less tedious.

There were quite a few `printf()` calls in some of the class definitions that were
used for testing the handling of WebVTT files in `HTMLTrackElement.cpp`. Printing
debug messages is an old, tried and true method of finding bugs so I didn't want to
remove these statements. I learnt that one could replace these statements with
a built-in logging mechanism Mozilla uses. No more using `printf()` and we still
retain the benefit of debug messages.

In retrospect, fixing all these 'easier' fixes first was a good idea. I was able
to learn about the proper coding styles to use when moving onto the harder issues,
as well as get a clearer understanding of how all the classes fit together. For example,
one of the fixes involved a method that was copied from one sibling class into another.
It is much better OOP practice to move said method into a common superclass. Doing this
helped me the inheritance structure of the classes I was dealing with and how they worked
together. This was definitely helpful information before moving on to the more difficult
bits.

### Into the Light

I have to admit that I can be stubborn sometimes. I love getting those "Eureka!" moments
during programming when you figure something out, and sometimes I'll spend longer than I
should trying to figure something out on my own to achieve that feeling. Sometimes, you just
need some help though. IRC was a pretty useful tool for getting instant feedback. The `#introduction`
and `#content` channels on MozNet full of helpful people. Also, asking Ms2ger questions via Bugzilla comments
was useful to sort some of the confusing bits of the review.

Bringing my work into the view of others, and asking the community at large for help, is something pretty
new to me. While we have group projects at school, working in a community is a very different experience than
a group of three or four others (in a good way!)

### C++ Level Up

I enjoy C++. It has strict rules on how to do things compared to languages I've been working
in recently (JavaScript), but that can be comforting. My C++ was a bit rusty but my skills
have definitely levelled up during this project.

In the same vein, I've also gotten a lot better at reading compile error messages from Mach.
After seeing enough of them, you start to see the pattern. I'm not sure if that makes me
a better programmer, a little crazier or both.

#### Defeats (and Rebounds)

### Rebase

My first time I ever did a git rebase was last week, when I had to rebase my current work
onto a current commit of mozilla-central. I guess the benefit of having my first rebase
experience with such a huge tree is that it can't really get much worse than that. As
expected, I had quite a few merge conflicts. What I found frustrating is that git would
use old merge conflict resolutions to solve the merge conflicts that arose during the rebase.
I'm not quite sure why git would use these old merge resolutions, as merging into a current
commit of m-c is most likely not going to have the same resolution as previous merges. It took quite a while
to go through the results of my rebase and fix all of oddities left over. I'm sure there
is a way to force rebase to not use old conflict resolutions. This wasn't the most efficient
way of doing a rebase, but I got it working and levelled up my C++ skills in the process by
hunting down all the compile errors. For next time, I need to read `man git rebase` quite
thoroughly before doing another rebase.

#### Future and Conclusions

Now that I have addressed Ms2ger's review, there are a few things left to do:

* Validation (throwing JS exceptions)
* `CueChange()`
* `TextTrackList` (the object that holds `TextTracks` for an `HTMLMediaElement` object

Ms2ger informed me this morning that there has been a spec change to text tracks
and WebVTT. [As you can see here](http://html5.org/tools/web-apps-tracker?from=7741&to=7742),
there is a proposal to abstract `TextTrackCue` into an interface which would then be implemented
by a `WebVTTCue`. I guess this would open the way for other text track implementations.
This is something I'll have to change, but not until after this Thursday, the 14th of March.

What is on Thursday, you ask? Well, the OSD700 WebVTT team is heading town to Mozilla Toronto
for a day of talking with Mozilla devs. The big event is a presentation we will be giving around
1:30PM EST. It may even be airing on [Air Mozilla](https://air.mozilla.org/) so you'll be able
to watch us talk about our work on WebVTT from the comfort of your internets. How exciting!
