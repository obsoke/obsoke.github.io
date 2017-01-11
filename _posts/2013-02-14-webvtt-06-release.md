---
title: WebVTT 0.6 Release&#58; First pass at DOM implementation
layout: post
date: 2013-02-14 11:30:00
tags: [open-source, osd700]
---
I've spent the last two weeks slowly making my way through the DOM implementation of
the `<track>` element. Well, most of it anyway: I *may* have forgotten about
implementing the main method one uses to actually add track elements to a `<media>`
element's track list but that was just a *slight* oversight on my part. Whoops!

I started out feeling like this, and in some ways I still do:

![This is how I felt during this adventure...](http://i.imgur.com/eO7LX75.jpg)

### What I did

Dave Humphrey provided a lot of the groundwork for the files I worked on in his initial
patch. He also provided the code for the `TextTrackCue` class. I worked on the `TextTrack`
and `TextTrackCueList` classes.

A `TextTrack` is the DOM representation of a `<track>` element. It has two internal
`TextTrackCueList` lists: one containing all the cues for that track, and one containing
all of the **active** cues; that is, cues that has start time prior to *currentTime* and
an end time after *currentTime*.

You can see the full patch I cut against
a version of mozilla-central from last night [here](https://gist.github.com/obsoke/4950639).
I've also posted the patch on Bugzilla, you can see that [right here](https://bugzilla.mozilla.org/show_bug.cgi?id=833385)

### Challenges

My first challenge was deciding how to use a `TextTrackCueList`
in my `TextTrack` object. Mozilla has their own way of doing things which I need to adapt to,
and using pointers is one of them. I started to look at other pieces of code in mozilla-central,
and discovered that I wanted to use an `nsRefPtr` to hold my `TextTrackCueList`. I am not exactly
sure that this is the right way to do this but I am sure I will find out during the first code review.

Another big challenge was deciding how to store the cues in a `TextTrackCueList`. Again, this is just
learning how Mozilla does things. I was pointed in the direction of [this MDN article on Arrays](https://developer.mozilla.org/en/docs/XPCOM_array_guide)
which proved quite helpful. I ended up going with a `nsTArray<TextTrackCue>` as my container. It can be
used just like a normal C++ array, with index operators and all. For example, here is a bit of code to
find a cue by its `Id` property:

{% highlight cpp %}
TextTrackCue*
TextTrackCueList::GetCueById(const nsAString& id)
{
  if(id.EqualsLiteral("")) return nullptr;
  for (PRUint32 i = 0; i < mList.Length(); i++) {
    nsString tid;
    mList[i].GetId(tid);
    if (id.Equals(tid)) {
      return &mList[i];
    }
  }
  return nullptr;
}
{% endhighlight %}

Even though this method was small, it proved quite difficult. Learning to use all of
the Mozilla-specific classes was not easy. For instance, nsString. Where does one learn
that methods like `EqualsLiteral` and `Equals` exist? By using MXR, of course! I spent a
bunch of time on MXR throughout my entire endevour, and using it to look at [header files](http://mxr.mozilla.org/mozilla-central/source/xpcom/glue/nsStringAPI.h),
which always seem to be very well documented, makes life a lot easier. Thanks Mozilla,
for documenting like pros!

Back to the code above. I used an int initially in that for loop rather than a PRUint32.
I had errors compiling because of it (Mozilla seems to force some compiler warnings to be
reported as errors). How does one know that one is supposed to use a PRUint32? MXR, reading other
code. I feel like I will be repeating myself a lot here, but MXR, reading other code and asking
questions in #introduction were my main resources. The rest of the method should seem pretty simple.
We create a new nsString, and use it to get the `TextTrackCue` id. If it's a match, we return it.
Otherwise, we return null.

The rest of the code is mostly setters and getters. Mozilla uses out parameters to return data
from getters. Setters are pretty standard. If you're interested in the nitty gritty details,
check out the patch!

### Next Steps

1. Add `addTextTrack` to HTMLMediaElement
2. Implement fixes as suggested in review
3. Use Marcus and Jordan's tests to see what is breaking, and fix things until everything
is green!


