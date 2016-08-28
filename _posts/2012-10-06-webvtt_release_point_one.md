---
layout: post
tags: [open-source, osd600]
date: 2012-10-06 23:30:00
title: WebVTT 0.1 Release (and so can you!)
---
### Release 0.1 Reflection
This week in OSD600, the class landed their tests into Humph's [seneca branch](https://github.com/humphd/webvtt/tree/seneca) on Github. Right now there are 270 tests, which I find pretty awesome. There are still a few pull requests open and I have thoughts of a few more tests to write, which mean that number will be going up. Good job, team! 

What's that, disembodied voice? More details on what went right and what went wrong during the release? Well, since you asked so nicely…

#### Git, I love thee
I've used Git and Github a bit in the past before, but always on projects which I created myself.  I use Github to find cool open source projects but I've never contributed to one myself. I used to find the idea of contributing to a huge project intimidating, but after working with Git and Github extensively over the past two weeks, I feel like those fears are long gone. My Git confidence level has gone way up. The best way to learn Git really is by just using it in real-world scenarios.

The power of branching in Git makes life so much easier. I remember tearing my hair out dealing with merge conflicts in Subversion. Good branching practices can make merging very painless, as I've learned in class. In one of his blogs, my classmate Rick also linked to a [great article on Git branching](http://nvie.com/posts/a-successful-git-branching-model/) that one of our other classmates linked to him. I don't necessarily suggest following that model to the T, but the artcle may help one understand how to work with branching in a more efficient manner.

What I do is this: in my webvtt repo, my 'master' and 'seneca' branches are kept clean and up-to-date with rillian and Humph's repos respecitvely. Then I just create new branches as I need to alter the code. Do my work. Tests that my changes haven't borked anything. Make a test branch to test merging back into the clean main branch. If that works, merge for real. Thousands of commits in between the beginning and end of the process. I don't know if I'm doing it right but so far this method has worked for me.

Some people may be having trouble with Git still. I've found a very cool Ruby gem called [githug](https://github.com/Gazler/githug) that helps you learn Ruby interactively, by giving you scenarios and asking you to perform Git-related tasks. Check it out if you need some extra Git practice. It's better than just reading about Git online, trust me!

#### The Power of Peer Review
Github makes it really easy to perform peer reviews. I can just go into someone's pull request and I have everything I need right there: diffs of what has changed, a list of all the commits in the pull request, and a discussion board. It would be nice if there was a way to quickly get the remote URL of the person making the pull request right on the pull request screens but a few keystrokes more isn't a huge deal.

Having all the necessary information in one place makes it easy to perform the main function of peer review: checking another person's code for mistakes. Let's face it: we all make mistakes. Having another pair of eyes look over your work helps reduce the amount of silly mistakes that make it into the origin repo.

I looked at a few people's pull requests, and left a comment whether it was a clean and perfect request (which never happened… again, we all make mistakes) or had a few issues. Usually the issues were documentation related, or a few tests were failing. When a weird issue would pop up, being able to discuss us with others, fully taking advatange of multiple minds working to solve the same issue, makes that solution come so much quicker than if one was working alone.

Some of my own problems were pointed out to me by others, like forgetting to reference the version of the W3C WebVTT spec draft I was writing tests against. While fixing these tests, I realized that all of my tests had the wrong naming convention. Would I, or anyone else, have noticed the names of my files were wrong? Maybe, but not being able to instantly submit my work and to have it reviewed by myself and others ensured less bugs and more happy faces all around.

I also have to give a shotout to fellow classmate Kyle Barnhart for his [insanely detailed WebVTT post](http://kyle.barnhart.ca/2012/10/web-video-text-tracks-webvtt.html). You, sir, are a gentleman and a scholar.

### Next Steps

There are a few more tests I have in mind to write for cue timings, and a few more pull requests that have not landed yet that could use review. Aside from that, it looks like the next steps are to address the issues in [rillian's webvtt repo](https://github.com/rillian/webvtt/issues). In class, I mentioned how I was mainly interested in working on parser stuff, but to be honest this is all new stuff to me. I'd be interested in working in any of these areas. As fun as it was writing tets, I feel like the next stage is going to double that fun. And intensity.

Oh boy...
