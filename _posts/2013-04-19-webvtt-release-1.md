---
title: WebVTT&#58; The Middle
layout: post
date: 2013-04-19 15:30:00
tags: [open-source, osd700]
---
It's been a while since my last post about WebVTT. A lot has been going on
since that last post in the beginning of March. The OSD team gave two presentations about
WebVTT to Mozilla Toronto: one during a class visit to MoTo and another
during MoTo's Open Web Open Mic event to some of the Toronto open source community.
Both events were a lot of fun! I was surprised by how excited some people seemed to get when they saw
WebVTT. When you work on a project, it can be hard to take a step back
and see the impact your project has on others, especially when you can
get so invested in said project. Good job team!

I haven't been able to spend as much time on WebVTT as I would have liked
over the past month. After the push to get things working for the first
Mozilla Toronto demo, I had an avalanche of final assignments fall onto me.
Now that they are finally behind me, I've been able to get back into the
swing of things.

### Review Issues

While I've been busy with school, rillian has been working on the patch.
Thanks a lot, rillian! There have been several iterations of the patch since.
As always, you can see the latest updates on [the Bugzilla bug](https://bugzilla.mozilla.org/show_bug.cgi?id=833385).
It's been reviewed quite extensively by bz and Ms2ger who brought up a few issues.

One of the issues had to do with nested templates. We were using nsTArrays like this: `nsTArray<nsRefPtr<TextTrackCue>>`,
which reads as 'an array of `nsRefPtr` which refer to `TextTrackCue` objects.' Apparently, the `>>` at the very end was
being interpreted as the `>>` operator on some older compilers. So we just added some 
whitespace to pad out the characters: `nsTArray< nsRefPtr<TextTrackCue> >`.  Easy fix!

In the review, it was suggested that we convert `nsAString` out parameters in
class getters to `DOMString`, a relatively new class in the Mozilla codebase.
I went ahead and did this, but it was not an easy fix. In fact, it was pretty
messy, and involved extracting a `StringBuffer` from an `nsAString` object and
using that to set the value of the `DOMString` out parameter. 

The code used to set getters went from this:

{% highlight cpp %}
void GetKind(nsAString& aKind) const
{
  aKind = mKind;
}
{% endhighlight %}

to this:

{% highlight cpp %}
void GetKind(DOMString& aKind) const
{
  aKind.SetStringBuffer( nsStringBuffer::FromString(mKind), mKind.Length() );
}
{% endhighlight %}

Yikes. That's what I call messy. To be fair, this is the only way to set the value
of a DOMString from an nsString, the type used internally to store strings.

It didn't get accepted. In retrospect, it would have been easier to just adjust the internal
members of the `TextTrack*` objects to use a `DOMString` rather than a `nsString`.
Once I clarify with others that this is the best way to go about with this fix,
I'll probably end up doing just that.

The first fix ended up making its way into the patch on Bugzilla. The pull request
on GitHub is still open due to the `DOMString` issue. If you're interested in following
that particular issue, you can [check it out here](https://github.com/RickEyre/mozilla-central/pull/10).

### Exceptions

Something I've wanted to start adding to the WebVTT DOM implementation for a while
now is exception handling. Firefox's C++ code doesn't use exceptions; I'm talking about
JavaScript exceptions. For instance, if one tries to use the `removeCue(cue)` method on
a `TextTrackList` JavaScript object which doesn't contain `cue`, a `NotFoundError` exception
should be thrown.

In order to do this, we first need to edit the WebIDL file which defines
the DOM interface. We must add a `[Throws]` declaration in front of every
method which throws an exception. For example, in `TextTrack.webidl`:

{% highlight cpp %}
[Throws]
void addCue(TextTrackCue cue);
[Throws]
void removeCue(TextTrackCue cue);
{% endhighlight %}

By using some crazy wizardry, this creates the necessary DOM bindings to use
exceptions. More specifically, it passes an `ErrorResult&` as the last argument
to our method. We can use this object to throw exceptions.

Let's take a look at `TextTrack::RemoveCue` and how we can throw an exception
if the cue passed as an argument is not already in the internal `TextTrackList`.

In our header file:

{% highlight cpp %}
void RemoveCue(TextTrackCue& aCue,
               ErrorResult& aRv);
{% endhighlight %}

In the implementation file:

{% highlight cpp %}
TextTrack::RemoveCue(TextTrackCue& aCue,
                     ErrorResult& aRv)
{
  // If the given cue is not currently listed in the
  // method's TextTrack object's text track's text
  // track list of cues, then throw a NotFoundError
  // exception and abort these steps.
  if( DoesContainCue(aCue) == false ) {
    aRv.Throw(NS_ERROR_DOM_NOT_FOUND_ERR);
    return;
  }
  // Remove cue from the method's TextTrack object's text track's text track
  // list of cues.
  mCueList->RemoveCue(aCue);
}
{% endhighlight %}

The generated bindings make it very easy to throw an exception. Now that
an `ErrorResult&` is being passed to our method, we simply call `Throw` on
the object and pass the error. One could search on MXR for the particular
error macro/constant they need; luckily, bz told me which to use in #content.

Initially, I was a bit confused when trying to implement exceptions. While
looking through MXR to see examples of how other classes implemented exceptions,
I'd often see `ErrorResult` initialized as a local variable within a method. Apparently,
this is only used for methods that catch exceptions. Methods that throw exceptions do it
through an `ErrorResult&` argument passed in by the generated binding methods. Oh, you
Mozilla engineers. You guys/gals are magic.

That particular pull request is still open at the time of writing. You can
[check out that pull request here](https://github.com/RickEyre/mozilla-central/pull/11).

### "1.0"

I'm really not sure if this release can be considered a 1.0 release. The code still
hasn't landed in Firefox (although it seems close). There are still things to do!
Some of those things include: maintaining and using `TextTracks.activeCueList`, finish
implementing exceptions on the rest of the `TextTrack*` classes, and fix all of the issues
raised in the reviews done by bz and Ms2ger. Concurrently, I believe we are at the point where
we can start using the MochiTests written by Marcuus and Jordan to bring other issues to light.

A big issue is the ever-shifting nature of the WebVTT spec. It seems like every week, the spec
changes - and not always for the better. For instance, there are now a list of rules associated
with every `TextTrack` that defines how the text tracks should be rendered. Also, `TextTrackCue`
is an abstract class from which we should be creating a new object: `WebVTTCue`. Not all these
changes make sense to me (Rules for updating cues? Why?) but I guess that is a part of the age-old
rift between spec writers and implementers.

Between the spec being in flux and the other items still on my to do list, there is still quite
a bit to be done before I'd be comfortable slapping the ol' 1.0 tag on. Now that school is
officially complete forever, I should have much more time to spend on WebVTT.

### The Middle

Speaking of school being officially done forever, this is my last official 'for school' post on my blog.
This isn't the end though, not by a longshot. I'll be continuing my work on WebVTT as a volunteer. I'm excited
to see what happens with the project in the coming few months!

Thanks to Humph for teaching the OSD classes to begin with. If you are a student at Seneca in CPA or BSD,
do yourself a favour and take these classes. The OSD classes are the best professional options offered at
Seneca, in my opinion. I'd also like to thank  my OSD teammates for a crazy 8 months. We're still alive!
Success!
