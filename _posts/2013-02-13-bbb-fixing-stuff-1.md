---
title: BigBlueButton HTML5 Fixin'
layout: post
date: 2013-02-13 13:55:00
tags: [open-source, cdot]
---
Now that I have my development environment fully configured, I am in a position to
finally contribute to BigBlueButton. Fred, CEO of Blindside Network, suggested that I
start with something simple.

The issue I am working on doesn't seem too difficult at first glance. The whiteboard section
of the client is the big part in the middle of the page where one can draw objects or place slides.
Currently, it seems to center in the browser viewport but it doesn't exactly scale to fit the viewport.
I believe this means that on an iPad, the whiteboard area will be fitted awkwardly into the window.
The goal is to make it so the whiteboard area will scale to fit the viewport of whatever device the
browser is on.

<a href="http://i.imgur.com/ogFcOAE.png"><img src="http://i.imgur.com/ogFcOAE.png"
alt="The whiteboard is not scaling with the viewport size in this image." width="600"
height="400" /></a>

_The whiteboard in this image is not scaling with the size of the viewport._

I am fairly certain that there are two steps to this process:

1. Change the CSS for the whiteboard div element to fit that big empty space
2. Scale the preview image (the image currently on the whiteobard) to scale as well

Anyway, off to try fixing this!
