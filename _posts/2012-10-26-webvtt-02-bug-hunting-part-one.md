---
layout: post
tags: [open-source, osd600]
title: WebVTT 0.2&#58; Bug Hunting, Part 1
date: 2012-10-26 01:30:00
---
Let's dive right into things, shall we?
### Validator failing on some legal escape values
For some reason, the JavaScript validator was failing on a bunch of tests that were using legal escape values in cue payloads. These include the left-right marker **\&lrm;**, the right-left marker **\&rlm;**, and the non-breaking whitespace character **\&nbsp;**. There are numerous places in the W3C spec (sections 3.1 and 3.3 as of 15 October 2012 edition) that describe how these characters should be handled, and none of those scenarios seemed to indicate that any failures should occur. This meant one thing: time to go JavaScript diving!

The code for the validator is contained in lib/parser.js (Now that I think about it, this should probably be renamed sometime in the future). After a bit of searching, I found the lines that seem to be causing this issue:
{% highlight js %}
else if(state == "escape") {
  if(c == "&") {
    // XXX is this non-conforming?
    result += buffer
    buffer = c
  } else if(/[ampltg]/.test(c)) {
    buffer += c
  } else if(c == ";") {
    if(buffer == "&amp") {
      result += "&"
    } else if(buffer == "&lt") {
      result += "<"
    } else if(buffer == "&gt") {
      result += ">"
    } else {
      err("Incorrect escape.")
      result += buffer + ";"
    }
    state = "data"
  } else if(c == "<" || c == undefined) {
    err("Incorrect escape.")
    result += buffer
    return ["text", result]
  } else {
    err("Incorrect escape.")
    result += buffer + c
    state = "data"
  }
}
{% endhighlight %}
We can see that the validator only currently handles the ampersand, less-than and greater-than escape characters. This looks easy enough to fix! I did need to do some reading up on using regular expressions in JavaScript, as I've never mixed the two together. Luckily, [MDN](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/RegExp) and [some other site with information on character classes](http://www.regular-expressions.info/charclass.html) helped me learn what I needed to know in order to continue. After some fiddling around, I came up with this:
{% highlight js linenos %}
else if(state == "escape") {
  if(c == "&") {
    // XXX is this non-conforming?
    result += buffer
    buffer = c
  } else if(/[nbsampltrg]/.test(c)) {
    buffer += c
  } else if(c == ";") {
    if(buffer == "&nbsp") {
      result += "\u00A0"
    } else if(buffer == "&amp") {
      result += "&"
    } else if(buffer == "&lt") {
      result += "<"
    } else if(buffer == "&gt") {
      result += ">"
    } else if(buffer == "&lrm") {
      result += "\u200E"
    } else if(buffer == "&rlm") {
      result += "\u200F"
    } else {
      err("Incorrect escape.")
      result += buffer + ";"
    }
    state = "data"
  } else if(c == "<" || c == undefined) {
    err("Incorrect escape.")
    result += buffer
    return ["text", result]
  } else {
    err("Incorrect escape.")
    result += buffer + c
    state = "data"
  }
} 
{% endhighlight %}
First, I added more characters to the regular expression on line 6. I then just added the appropriate conditional statements. Finding the values for the unicode characters was as easy as a Google search which returned [this](http://www.fileformat.info/info/unicode/char/a0/index.htm) handy page.
After recompiling the node application and running our test suite using it, the tests now passed! Hooray! The pull request is [currently open](https://github.com/humphd/webvtt/pull/36). After a peer review, the code should be ready to land.
### strip-vtt.py not stripping .vtt files correctly when CLRF endings are present
I noticed that some of the files in known-good were failing for no good reason. When I looked at the vtt file that the test was being ran on, I found that most of the comments were being left in the file. This would break any validation as the first line would not be the WEBVTT signature. After realizing what was happening, I opened up strip-vtt.py to get a better look at what was happening. Here are the lines producing this particular error:
{% highlight python %}
testFile = open(sys.argv[1], 'r')
fileData = testFile.read()
# Rip the VTT
vttInfo = fileData[fileData.find('*/\n') + 3:]
{% endhighlight %}
The last line looks for the end of our comment marker (\*/ followed by a newline character), advanced by 3 (still not sure why that happens) and then takes a range from that index to the end of the string, and returns it to vttInfo. Python is awesome to debug because I can just pop into the REPL and check what is happening myself. When I did this, I noticed that the files that were failing contained \r\n as the newline character. This must have been what was breaking some of these tests.

I decided to ask in the **#seneca** IRC channel for advice. Caitlin suggested I use a regular expression instead of the find method, and I agreed. Again, my RegEx is not up to par but [Python's amazing doucmentation](http://docs.python.org/library/re.html) made that a non-issue. After a few iterations, I ended up with the following:
{% highlight python %}
testFile = open(sys.argv[1], 'rb')
fileData = testFile.read()
# Rip the VTT
res = re.search(r"/\*.*\*/\r?\n?", fileData, re.M | re.S)
if res == None:
	print "Malformed test file at:", sys.argv[1]
	return -1

vttInfo = fileData[res.end():]
{% endhighlight %}
The regular expression searches for a begin-comment marker, followed by any amount of characters, followed by a end-comment marker, followed optionally by a \r character and then optionally by a \n character. The two options at the end search multiple lines, and also include newlines as matches for the **.** in RegEx. For some reason, if I attached a **^** anchor to the beginning of the string, it wouldn't match on a bunch of the test files. I suspect the BOM character is at the beginning of some files but I'm still not 100% sure. 

After running our test suite again, I noticed that all affected tests were now passing, and nothing broke as a result of it. Victory!

I had a strange issue where Python was complaining about SyntaxErrors on lines that were clearly syntax-perfect. I think that my tab settings in vim were making Python angry. I opened the file in Sublime Text 2 and re-tabbed the lines it was complaining on, and that seemed to fix it. Silly vim!
### Can a voice tag be nested?
Two files left in known-good now! Both were failing for the same reason: they contained nested voice tags in the cue payload. I couldn't find anything in spec about nested tags and whether they were legal. The validator doesn't complain if any other tags are nested; it specifically checks to see if it is about to enter another voice tag, and then reports an error. The voice tag gets turned into a span tag, which can be nested. I was confused, to say the least.

I decided to seek answers in **#media** on MozNet, asking if anyone was well-versed in WebVTT syntax. I wasn't sure if I should just write a huge wall-of-text question explaining everything or slowly work up to a question by first getting someone in the channel to talk to me. I went with the latter approach and it worked. The channel operator suggested that I contact rillian. So I did!

Rillian was very friendly and helpful. He suggested a number of things for me to think over, such as "How does WebKit handle nested voice tags?" and  "Think about what event should occur if the parser/validator encounters a nested tag… what actions should it take?" (I'm paraphrasing). He also provided me with a few ways to contact people involved with the spec itself, the W3C. Personally, I'd like to have this defined more clearly in the spec, so future developers/content writers don't end up as confused as I am!

Part two will include a resolution (hopefully!) so the question of nested voice tags, and more bug wrangling.
