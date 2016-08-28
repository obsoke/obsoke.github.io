---
title: WebVTT 0.5 Release&#58; Set Sail for Fail
layout: post
date: 2013-01-17 23:35:00
tags: [open-source, osd700]
---
For my first release of the semester (and fifth overall in OSD), I wanted to accomplish
a few things:
First,  build Firefox using a commit from around the date of [rillian's initial patch](https://bugzilla.mozilla.org/show_bug.cgi?id=629350).
Second, once I've confirmed I was able to build Firefox from ~March 16, 2012, I would apply rillian's patch.
Lastly, compile Firefox with rillian's patch containing initial work on the track element.
Unfortunately, I got a _bit_ stuck on step one. But allow me to back up a bit.

My first problem was finding the sha of a commit I could use from around the time of rillian's patch,
which was uploaded to Mozilla's bug tracker on March 16, 2012. I learned that I could use some options
with the `git log` command that will make this task nice and easy. These options are `--before="DATE"`,
`--after="DATE"`, `--since="DATE"`, and `--until="DATE"`. For example, using
`git log --since="3/15/2012" --until="3/17/2012"`, I was able to find a number of commits from
around the desired date that I could choose from. Neat! Check out `man git log` for more details.

I wrote my `.mozconfig` file, and then ran `make -f client.mk build`. At this point in the tree's history,
I don't believe Mach, the new build system, exists yet. Running `./mach` produces a 'No such file or directory'
message. I ran the build, went away for 20 minutes, and came back to see... Build failed! I've had the luck of choosing
a sha that happened to be a bad commit on non-Win32 systems. This had to be the first time I got the short
end of the stick as someone who develops on Linux! Humph helped me find a sha that contained a fix. I checked
it out and started the build again. 20 minutes later, another build failure! This time, a linker error. Some
symbol in some file was not defined.

Using the online Mercurial repo, I searched the commit history of a file that I believed
was causing linking errors, mozalloc.h. I found a commit with the sha I wanted to try
compiling. However, this was the sha for Hg, not the GitHub mirror. I was faced with the
problem of somehow finding the git version of this commit. I found a pretty handy way
to do this in git, and that is by searching commit messages. I used the following syntax:
`$ git show ":/Bug 738176"` to bring up the diff that contained that message, as well as
the sha for that commit. I believe this syntax searched the _beginning_ of the commit messages
for the string that follows the slash. Huzzah! I was able to `git checkout d6f5796`, and then create
a new branch from that commit (which I have aliased to `git nb`). Unfortunately, the build
still did not work! I was getting the same linker error.

At this point, I should have realized that something was wrong with my development environment,
and not mozilla-central. I kept trying random commits, starting the build, went away
for 20 minutes and then returned only to find yet another build error. It was pretty demoralizing, to be honest.

At this point, I gave up on trying to build an old version of Firefox. I checked out the master
branch, did a `git pull` to make sure I had the latest changes and then built the newest version
of the browser using the new Mach build system. Everything went well! I needed a victory at this point,
and to be reassured that my development environment did not become sentient and was now plotting against me.

Just for fun, I tried applying rillian's patch to a current version of the mozilla-central
codebase. As expected, it failed. Half of the files no longer exist, and the other half couldn't be merged
in cleanly. I felt bad for Humph, who was working on updating the patch for use with the current
codebase.

So that's my pathetic story. Not much to show for this release, besides a few new tricks I learned
with git that should be useful. Learning how to navigate [MXR](http://mxr.mozilla.org/mozilla-central/) and the Hg online repository were
useful skills to learn at this point, before things start getting _really_ difficult.

As I volunteered to drive the DOM implementation phase of our project, I figure I'll research how
other elements have been done. My biggest concern with working in this code base is learning when to
use what macro, or which types to use. As Humph mentioned in class today, only by asking questions
and reading code is going to be necessary to completing my goal.

Onwards!
