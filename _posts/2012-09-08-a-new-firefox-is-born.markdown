---
layout: post
tags: [open-source, osd600]
---
Back when I was still in Philosophy at York, my friend [Aaron Train](http://aaronmt.com "Aaron Train") told me he was taking an open source class in his program at Seneca. I was pretty jealous, and I thought "I wish my program had an open-source class!" This was one of many thoughts that led me to believe that I was in the wrong program. Now Aaron works at Mozilla, and I'm starting my last year in CPA, and I'm taking that same open source class. Oh, the circle of life… or development.

Our first lab in OSD600 was to download and compile the source code for Firefox. I have experience with Git and GitHub, so I quickly forked my own copy of [mozilla-central](https://github.com/mozilla/mozilla-central "Mozilla Firefox on GitHub"). I then began to clone the repo onto my dev computer, a 15" Core i7 MacBook Pro. I have a pretty fast Internet connection and it still took over 15 minutes to clone this repo, making it the largest code repository I've downloaded through git!

Now it was time for the hard part: to build Firefox. Our leader into the wilderness that is OSD600, David Humphrey, warned us the process may be long and difficult so I wearily opened the [build instructions](https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Mac_OS_X_Prerequisites "MacOS X Build Instructions for Firefox") for Mac OS X and began to read.

The first step was to install Xcode. Luckily, I already had it installed as I'm taking Apple Development as well this semester. The next step was to get the build dependencies. I thought this step would be a huge pain, but [Homebrew](http://mxcl.github.com/homebrew/ "Homebrew") made this step very easy.

The last step before building (and in my opinion, the most important besides build dependencies) is to create your .mozconfig file. Using the sample config file from the build instructions, I tweaked mine a bit with a little help from Aaron. Here's mine below:

```
. $topsrcdir/browser/config/mozconfig
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-ff-dbg
mk_add_options MOZ_MAKE_FLAGS="-j12"
mk_add_options AUTOCONF=/usr/local/Cellar/autoconf213/2.13/bin/autoconf213
ac_add_options --enable-debug
ac_add_options --disable-optimize
CC=clang
CXX=clang++
```

As you can see, there are a few changes from the stock config file. I had to tell the config file to use Clang as my compiler instead of GCC, and to use the version of autoconf I downloaded using Homebrew. However, the most important changes can be found on the third line. I first removed the **-s** flag from the MOZ_MAKE_FLAGS option, as I was curious to see the output of the build process. The '-s' flag silences build output to the terminal. The more important change was to the **-jN** option. In the stock config file, N has a value of 2. My N has a value of 12. According to [this page on the Mozilla wiki](https://developer.mozilla.org/en-US/docs/Developer_Guide/Mozilla_build_FAQ?redirectlocale=en-US&redirectslug=Mozilla_Build_FAQ#Making_builds_faster), **-jN** enables parallel builds, which takes advantage of multi-core systems to build Firefox in a shorter amount of time. N should be a value "1.5 to 2 times the number of CPUs in your machine" as the wiki states. This fact was pointed out to me by Aaron Train, who suggested I change the value to 12.

I was finally ready to build! The wiki suggests running the **configure** and **build** commands separately on your first build. The first time I ran configure, I had actually forgotten to install autoconf via Homebrew. I guess this just shows how important it is to read the documentation before starting anything. After resolving the issue, the configure passed properly and I ran the build command. My computer started to heat up and about a minute later, the fans were going full blast. I probably could've cooking an egg on it. Removing the **-s** flag from the .mozconfig caused the Terminal to spew out walls of text. 17 minutes later, the build was complete. The **-jN** option really cut down compile time if you have the processor power!

After the way David Humphrey described how compiling could go to the class, I kind of feel bad that I don't have anything worse to report during my first build experience (although I know I shouldn't as I foresee many frustrated posts in my future). At least I can breathe easy now knowing that another firefox has been born. Maybe it can give me a fitting allegory to end this post with.

<a href="http://i.imgur.com/HL0Ks.png"><img src="http://i.imgur.com/HL0Ks.png" width="640" height="360" alt="A screenshot showing my built copy of the Firefox Nightly. Yay!" /></a>
Or not.
