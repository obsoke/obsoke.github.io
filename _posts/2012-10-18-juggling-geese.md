---
layout: post
tags: [open-source, osd600]
title: WebVTT Release 0.2 Status&#58; Juggling Geese
date: 2012-10-18 00:05:00 
---
This week has been pretty crazy with midterms and I haven't had much time to start fixing any bugs in the [WebVTT JavaScript Validator](https://github.com/daliuss/node-webvtt/blob/master/lib/parser.js) yet. When I've had time, I've been doing a lot of prep work and planning so I can really dive into this stuff over reading week. Here is what I've been thinking of lately, and what I've learned.
### The task at hand
Things have changed a bit since my last blog post. The tool that was once referred to as the WebVTT JS parser has been rebranded as the WebVTT JS Validator. This is due to the fact that the tool validates the WebVTT file's syntax according to the spec rather than create a data structure based on the WebVTT file's contents. There are still bugs related to the JS validator. Kyle listed a bunch of bugs [on his blog](http://kyle.barnhart.ca/2012/10/webvtt-test-bugs.html). There are also 32 files in either our 'known-good' or 'known-bad' test folders which could be failing due to bugs in the validator. Fixing these is my first task.

My second task is to use the validator as a base to create a WebVTT JavaScript parser. In Monday's class, I asked whether having a JavaScript-based parser would be necessary. "After all," I thought, "we are building a C parser and WebKit has built a [C++ parser](). Heck, we are even going to have a Rust-based parser. How many parsers do we need!?" Then Humph told us about polyfills.
#### Polyfill want a cracker?
(Yep. Get used to groan-inducing puns like that if you read this blog. Apologies in advance.)
A [Polyfill](http://en.wikipedia.org/wiki/Polyfill) is our answer to the question of "How will WebVTT work on older browsers/browsers that do not implement the spec natively?". It is a downloadable piece of code that will fill in any features not supported by the browser itself. Because JavaScript can create DOM objects for the browser to use, a JavaScript parser would actually be very beneficial for older browsers that don't implement WebVTT, or any browser that chooses not too. Also, if it's done exactly to spec, it would be a great reference parser. There are a lot of possibilities which make me very excited to be working on the project! Of course, I first must first validator bugs.
### Testing bug fixes
So far, I see my bug fixing process going like this: make a WebVTT file that exhibits the bug, edit the parser code, and then check it against the WebVTT file until it works as intended. Seems simple enough. Since we already have a way of testing on the command line via Humph's [node application](https://github.com/daliuss/node-webvtt), I'll use that. In order to use the tool in my tests, I needed to learn how to rebuild the Node app with my modified parser.js. I have very little experience with Node so this would take some research on my part. Thankfully, it didn't take long to find the answers I needed.
#### Rebuilding the Node application
Rebuilding the Node application is a pretty straight-forward task. Since we initially used the npm (Node Package Manager) tool to install Humph's version by typing
```
npm install webvtt -g
```
at the command line, I searched for documentation on npm and install, which I [easily found](https://npmjs.org/doc/install.html).

npm can create a package from Node code in a few ways, but the easiest way is just by having a package.json file in the root of your Node app directory, navigating to said directory on the command line and then running
```
npm install -g
```
. npm will use the package.json file (which describes the Node application) to build the package and then install it. The **-g** option installs the package globally to be used anywhere on the command line. When I first looked at the package.json file, I was pretty confused as to what some of the properties meant. I found a very cool [interactive web tool](http://package.json.jit.su/) that explains what all of the options in the file do.
### To semicolon or not to semicolon
I wanted to end off with an issue I've been thinking about for a few days now. If you take a look at the current [validator code](https://github.com/daliuss/node-webvtt/blob/master/lib/parser.js), you may notice something funny. There are no semicolons! I know that there are debates in the JS community about whether to use semicolons as statement terminators or not. While JavaScript interpreter will add semicolons to end of statements when they are not there, this can lead to some silly bugs. Some people seem to think that years of typing that extra character is going to decrease their lifespan or something. Some people just like the way it looks. Either way, I'm a fan of using the language the way it's meant to be used, and the way that will cause the least amount of headaches so I'm all for using semicolons.

This is the question: apparently, the original writer of the validator moved on to other projects. Should I fork my own version of the script and add semicolons for the sake of those developers who will come after me, or suck it up and just think to myself "When in Rome…"

So far, I haven't come to a resolution. My priority now is to get started with bug fixing, so I'll suck it up for now but if I have time, I'd really like to add semicolons.

Next time on the **Dale in Open Source** show, the bug fixing will commence!
