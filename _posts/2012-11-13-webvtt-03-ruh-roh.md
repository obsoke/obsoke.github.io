---
layout: post
title: WebVTT 0.3&#58; Ruh Roh!
date: 2012-11-13 02:15:00
tags: [open-source, osd600]
---
I feel like a terrible parent. I started writing the node-ffi binding code and then abandoned it. For a few days, 
I was occupied with other subjects. Thankfully, when I came back, our unit test code base grew into an infant into an
interesting project... child thanks to other OSDers. But now I feel like it's grown into an out-of-control teenager.

Oh boy.
### Let's back up a second...
When I finally had some time to return to the world of OSD, I was pleased to learn that in my absense, Caitlin and David
have been working on getting the unit tests going working. They were running into some problems (which I shall discuss shortly) 
so I joined in to help out. Since David's GitHub repo contained the latest version of the code at the time, I did a <code>git fetch</code> on
David's branch, checked out a new branch, and then did a <code>git merge</code>.
Merge conflict!
After initially looking at the file containing the conflict in my editor of choice (Vim), I realized that all I needed to do was overwrite all of my changes
with what the others currently had, as my code was now out-of-date. After performing said actions and studying the new additions, it was time to get started! Or so I thought...
On the command line, in the root of the webvtt directory, I ran <code>nodeunit test/unit/sample.js</code>, which **should** run node unit on our
sample unit test file. However, what came back ws the following:
{% highlight js %}
assert.js:102
  throw new assert.AssertionError({
        ^
AssertionError: Could not determine the `ffi_type` instance for type: Object
    at Type (/Users/dale/Homework/OSD600/webvtt/test/unit/node_modules/ffi/lib/type.js:121:3)
    at CIF (/Users/dale/Homework/OSD600/webvtt/test/unit/node_modules/ffi/lib/cif.js:41:19)
    at ForeignFunction (/Users/dale/Homework/OSD600/webvtt/test/unit/node_modules/ffi/lib/foreign_function.js:33:13)
    at /Users/dale/Homework/OSD600/webvtt/test/unit/node_modules/ffi/lib/library.js:66:16
    at Array.forEach (native)
    at Object.Library (/Users/dale/Homework/OSD600/webvtt/test/unit/node_modules/ffi/lib/library.js:45:28)
    at Object.<anonymous> (/Users/dale/Homework/OSD600/webvtt/test/unit/libwebvtt.js:105:21)
    at Module._compile (module.js:449:26)
    at Object.Module._extensions..js (module.js:467:10)
    at Module.load (module.js:356:32)
{% endhighlight %}
The last file that I can recognize in the stack trace is 'libwebvtt.js', citing line 105, column 21 as the source of the issue.
This is what begins on line 105 of libwebvtt.js:
{% highlight js%}
var libwebvtt = ffi.Library('libwebvtt', {
  'webvtt_parse_chunk': [ webvtt_status, [webvtt_parser, ref.types.Object, webvtt_uint] ],
  'webvtt_finish_parsing': [ webvtt_status, [webvtt_parser] ],
  'webvtt_parse_cuetext': [ webvtt_status, [ webvtt_parser, webvtt_uint ] ],
  'webvtt_create_parser': [webvtt_status, [webvtt_cue_fn_ptr, webvtt_error_fn_ptr, ref.types.Object, exports.ParserPtr ]],
  'webvtt_delete_parser': [ref.types.void, [webvtt_parser]]
});
{% endhighlight %}
Well, this is awfully familiar... it is the code that binds our JavaScript to the C library! At this point I was tired
so I decided to sleep on what I had just learned.

### The Next Day
Coming back to the code, I thought to myself "What is an 'Object' type in this context? I know what an Object is in Java, but how does that translate to C++?"
As far as I knew, C++ did not have a type called Object.
I looked at the [C++ header](https://github.com/dperit/webvtt/blob/caitp-unit/include/webvtt/parser.h) for the parser and noticed
that these functions were expecting void pointers as arguments where we were passing in 'ref.type.Object'.
So I decided to change all the references of 'ref.types.Object' to 'voidPtr'. Apparently, I was the only one having an issue with this, which I found a bit strange.
I ran nodeunit and... something different happened! This is always a good result when solving bugs, in my opinion.
{% highlight js %}
sample.js
parse_test called with invalid parameter onCue:
  received type "object", expected "function"
parse_test called with invalid parameter onError:
  received type "object", expected "function"

FAILURES: Undone tests (or their setups/teardowns): 
- sampleTest

To fix this, make sure all tests call test.done()
{% endhighlight %}
David and Caitlin fixed this one. I believe the issue was that we were passing a callback to a callback when it was expecting just a function.
While they were doing that, I opened up a pull request to [update the .gitignore](https://github.com/humphd/webvtt/pull/43) as I was sick
of always working in a dirty directory in Git due to all the files produced by autoconf and make.

After fixing that, a new error appeared:
{% highlight js %}
Removed 26 bytes of comments
error@createParser(): Could not determine the `ffi_type` instance for type: Object
error@createParser(): Could not determine the `ffi_type` instance for type: Object
error@createParser(): error setting argument 0 - don't know how to set callback function for: undefined
Error creating webvtt_parser

OK: 0 assertions (118ms)
{% endhighlight %}
Oh boy. At this point, I think I need to sleep on this one as well.

### Lessons
At this point, I have come to a few conclusions:

* When you step away from an open source project for a few days, it moves on without you. In school, if I  work on
an assignment and then put it off for a week, I can start right where I left off. When working on a project with others, you don't have this
convenience. This isn't a bad thing; quite the opposite as work can get done without you. It is just something I am not used to yet, and coming back to a code base that has changed
quite a bit is a bit jarring at first. Thankfully, people in OSD600 comment their code. Hooray!
* I am not quite sure how I feel about FFI at this point in time. I almost feel like it has been more trouble than it is worth. We haven't
even gotten to the point where we can write unit tests yet! I am almost tempted to take a look at some C-based testing suites. However, I know none
of us really want to write tests in C. Do we really want to compile a file every time we make a change? Not really. I really want to get node-ffi to work
though, so I will try to get that done on the morrow.

This all requires some thinking on. And sleeping on! Next time: the thrilling conclusion, and the release of 0.3!
