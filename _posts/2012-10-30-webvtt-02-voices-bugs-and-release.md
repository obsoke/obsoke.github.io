---
layout: post
tags: [open-source, osd600]
title: WebVTT 0.2&#58; Voices and Release
date: 2012-10-30 01:40:00
---

### Previously, on A Few Hours of WebVTT with Dale...
In my [last blog
post](http://daleio.dev/2012/10/26/webvtt-02-bug-hunting-part-one.html),
I put forth the question of whether voice tags could be nested. The [JS Validator](http://quuz.org/webvtt/) complained when one would nest voice
tags and I was curious as to why. I couldn't find anything in the spec
to suggest that nested voice tags were not legal in the syntax. Rillian
suggested I check out WebKit's WebVTT parser to see how they handle
nested voice cues, and that is what I did.

### Spoiler: Nested voice tags are legal
> ProTip: If you want to search for a file in a GitHub repo, hit the 't' key on the repo's page to get a fuzzy file finder. GitHub, I love thee!
After some searching, I believe I found the code in WebKit that handles
tags, in
[WebVTTParser.cpp](https://github.com/WebKit/webkit/blob/0eb84c77e494b6c69033d4df2c8fdb87d6239546/Source/WebCore/html/track/WebVTTParser.cpp#L357-375):
{% highlight cpp linenos %}
case WebVTTTokenTypes::StartTag: {
    RefPtr<HTMLElement> child;
    if (isRecognizedTag(tokenTagName))
        child = HTMLElement::create(tagName, document);
    else if (m_token.name().size() == 1 && m_token.name()[0] == 'c')
        child = HTMLElement::create(spanTag, document);
    else if (m_token.name().size() == 1 && m_token.name()[0] == 'v')
        child = HTMLElement::create(qTag, document);

    if (child) {
        if (m_token.classes().size() > 0)
            child->setAttribute(classAttr, AtomicString(m_token.classes().data(), m_token.classes().size()));
        if (child->hasTagName(qTag))
            child->setAttribute(titleAttr, AtomicString(m_token.annotation().data(), m_token.annotation().size()));
        m_currentNode->parserAppendChild(child);
        m_currentNode = child;
    }
    break;
}
{% endhighlight %}
This is how I understand the code: First, we check if the tag is a
recognized tag name. That method, defined in
[WebVTTParser.h](https://github.com/WebKit/webkit/blob/0eb84c77e494b6c69033d4df2c8fdb87d6239546/Source/WebCore/html/track/WebVTTParser.h#L68-75), looks like this:
{% highlight cpp %}
static inline bool isRecognizedTag(const AtomicString& tagName)
{
    return tagName == iTag
        || tagName == bTag
        || tagName == uTag
        || tagName == rubyTag
        || tagName == rtTag;
}
{% endhighlight %}
None of these tags seem like a voice tag. The parser moves on! Next, on line 7, there is mention of a token with the name 'v'.
If the token is a v tag, an element is created of type 'qTag' and a
reference to the element is returned to child. If the element was created,
further processing on the element, such as setting attributes, is
completed before attaching the objects to the DOM. No special handling
of nested tags seems to be present.

I'm not really sure what a 'qTag' is. Out of all the WebVTT files in
WebKit, this code block seems to have the only mention of a qTag. I
really wish GitHub had the ability to grep a repo...

The spec says nothing disallowing nested voice tags. WebKit does nothing
special to disallow nested voice tags. Therefore, I guess we are
allowing nested voice tags! Jordan contributed the code for this one.
Thanks dude!

Links:
* [Issue](https://github.com/obsoke/node-webvtt/issues/4)
* [Pull request](https://github.com/obsoke/node-webvtt/pull/7)

### The Other Fixes
I just wanted to recap what else I did for release 0.2.
I fixed strip-vtt.py so it will smartly separate the metadata from the
WebVTT data, regardless of line endings. Thanks for Caitlin for help on
fine tuning the regular expression.

Links:
* [Issue](https://github.com/obsoke/webvtt/issues/2)
* [Pull request](https://github.com/humphd/webvtt/pull/36)

I also fixed the validator not accepting valid escape values for
non-breaking whitespace and the right-to-left/left-to-right marker.

Links:
* [Issue](https://github.com/obsoke/node-webvtt/issues/5)
* [Pull Request](https://github.com/humphd/node-webvtt/pull/1)

I have to open another pull request moving the rest of the tests from
known-good into good, but I'm waiting for the strip-vtt.py fix to land
first, which already moves a few tests along with it.

### WebVTT Release 0.2 Reflections
The issues found in in known-good have been resolved but there is still
the known-bad folder to tackle. Also, I'd like to get in touch with the
W3C about clarifying the spec in regards to the legality of nested tags.

When I started this task, I thought blowing through all the bugs in the
known-good and known-bad folders would be a piece of cake. Little did I
know that each issue takes research, testing, analyzing other people's
code and patience.

I was originally going to work on a JavaScript polyfill for WebVTT once
I was done fixing validator bugs but it seeems there [are already quite
a few of
those](http://www.w3.org/community/texttracks/wiki/Main_Page#WebVTT.2FSRT_polyfills)
around. So I need to find a new task to work on. That's getting ahead of
myself though, as there is still more bugs to fix in the validator.
