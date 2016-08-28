---
title: BigBlueButton&#58; SVGs and the coolest Ninja Turtle
layout: post
date: 2013-02-20 14:30:00
tags: [open-source, cdot]
---
Between the snow storms, Family Day and a recent avalanche of homework, I haven't spent
much time in CDOT lately. However, with a large amount of pressing work behind me and reading week
just around the bend, I expect to spend a lot more time hacking away on BigBlueButton.

Last time I left off, I had just started working on a bug where the whiteboard area of the
HTML5 client was not scaling to fill its containing DIV. This means that no matter what
one's resolution is, that whiteboard area will be the same size. This is not ideal if we have
a high-resolution display: we want to be able to take advantage of all those pixels!

Since our client code uses Backbone.js, I figured I should learn a little bit about the popular framework.
I've heard a lot about Backbone a lot over the past year, but never used it until now. It is a JavaScript-based
MVC framework that seems to revolve around models and event listeners. It attempts to solve the problem which
occurs when building large applications in JavaScript: namely, spaghetti code and callback hell.
Backbone attempts to solve this issue by providing some much-needed structure to building large-scale web
applications. There is a ton of information, as well as API documentation, that can be found on
[Backbone's homepage](http://backbonejs.org/). I'm not going to list every single
thing I found interesting about Backbone, but I will present this short list of interesting features:

* Event listeners and emitters seem very easy to use. `object.on()` and `object.trigger()`.
Seems simple enough, as well as very powerful.
* Creating your own model is as easy as passing domain-specific properties to
`Backbone.Model.extend()`, which returns your new object.
* A Collection is just an ordered list of Models.
* A View object can be bound to a Model, allowing for updating only certain parts of
a page on a Model change, rather than redrawing the entire page.
* Backbone also contains a Router, a Utility class and the awesome
[Underscore.js library](http://underscorejs.org/).

After reading a bit about Backbone, I am actually quite interested in trying
it out on a personal project sometime soon. I now understand why it has been
so popular over the past year or so.

The BBB HTML5 client is built with Backbone. The client also makes use of a bunch of
new web technologies to replicate the functionality found in the Flash client. One of
these technologies is SVG, or Scalable Vector Graphics. SVG is a standard that allows
browsers to create and interact with vector graphics on the DOM. We use SVGs to draw and
interact with objects on the HTML5 whiteboard. We are using a JavaScript library called
[Raphael](http://raphaeljs.com/) that makes working with SVGs much easier.

Calvin, one of the Blindside developers working on BBB, suggested a library/wrapper for Raphael
called [ScaleRaphael](http://www.shapevent.com/scaleraphael/)
in order to fix this scaling issue. It is essentially a wrapper for Raphael that allows one to easily scale a Raphael
SVG canvas up and down. That should make solving this issue much easier.

Anyway, that's all I really had to say right now. Personally, I find all of these different JavaScript libraries very
interesting and I love hearing about them.

Hopefully in a day or two, I'll have this issue resolved. Expect a post in which I talk about the solution soon!
