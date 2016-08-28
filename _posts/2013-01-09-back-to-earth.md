---
title: Back to Earth
layout: post
date: 2013-01-09 22:00:00
tags: [open-source, osd700]
---
After some well-needed rest, it's time for me to dive back into the world of WebVTT with
team OSD in OSD700. There are only a handful of us this semester and there is **a lot**
of work to do. Sounds like a fun time to me!

Our end goal is still to implement the [WebVTT standard](http://dev.w3.org/html5/webvtt/)
into Mozilla Firefox. This semester, each student is going to drive a different area
of the implementation. Personally, I think this is a pretty good approach. I'd like
to drive the DOM implementation of WebVTT. The Document Object Model (DOM) is a
representation of the objects found in HTML documents. It has an API which is
accessible through JavaScript. The DOM implementation will allow developers to
use JavaScript to program their WebVTT-equipped web apps with ease. At least,
that's the plan.

WebVTT files are loaded into the DOM with the `<track>` element.
The [W3 Wiki](http://www.w3.org/wiki/HTML/Elements/track) describes how one uses
the element. `src` is the location of the WebVTT file to use. You can
also specify a `kind` although the effects of doing so are a bit unclear.

Much more useful is the actual [HTML5 specification](http://www.w3.org/html/wg/drafts/html/master/embedded-content-0.html#the-track-element) which pretty well details the
`<track>` element in full. It also includes an IDL implementation of the DOM interface!

{% highlight java %}
interface HTMLTrackElement : HTMLElement {
  attribute DOMString kind;
  attribute DOMString src;
  attribute DOMString srclang;
  attribute DOMString label;
  attribute boolean default;

  const unsigned short NONE = 0;
  const unsigned short LOADING = 1;
  const unsigned short LOADED = 2;
  const unsigned short ERROR = 3;
  readonly attribute unsigned short readyState;

  readonly attribute TextTrack track;
};
{% endhighlight %}

IDL stands for Interface Description Language, and that's pretty well what it is.
It's a language used to define interfaces. That's pretty well I know at this point.

Right now, I feel like I need to spend the new few days synthesizing all of this information.
There is a lot to take in. However, I have devised a rough plan of the next few weeks!

Week 1 - Synthesizing information, Research on IDL and track

Weeks 2/3 - Look at other media DOM implementations such as video.
Use this information to start trying to hack in the track element.
### Week 3: Presentation 1

Weeks 4/5 - Continuing to hack track in

Week 6 - **Presentation 2**, hopefully at this point I'll have something to show. Maybe an in
class demonstration of some API calls from the developer console in Firefox.

Honestly, at this point, I have no idea how the rest semester will look. I gave myself a bit
of time to hack the track element in as I believe it will not be an easy feat. IDL looks similar
to Java. After that,
testing, helping write DOM tests and whatever else I can do. As there are so few of us trying
to accomplish quite a large task, I feel as if we will be changing job hats quite  a lot over
the next few months. While my hair doesn't really work well with hats, I'm pretty excited for
the next few months. I learned so much in the first semester, and this semester looks like a
repeat in that category!
