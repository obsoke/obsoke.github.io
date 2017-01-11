---
layout: post
tags: [open-source, osd600]
title: WebVTT 0.3&#58; Node, node-ffi and I
date: 2012-11-04 17:15:00
---
In addition to continuing to fix bugs in the [WebVTT JavaScript validator](https://github.com/obsoke/node-webvtt/blob/master/lib/parser.js), I
have decided to take a look at possible ways to write our unit tets. In
class, Humph mentioned some pretty neat modules for node like
[node-ffi](https://github.com/rbranson/node-ffi), which allows one to
bind JavaScript to C functions. Why do this in the first place?
Personally, as much as I love C, I wouldn't want to write a test suite
in it. I've had experience writing unit tests in JavaScript and Ruby and
JS was definitely a more pleasant langauge for me to use. By using a
tool such as node-ffi, we can write JavaScript that will test
our C code.

### Getting started with node-ffi
The first thing I did was create a new git branch to work off of. You can view that git branch [here](https://github.com/obsoke/webvtt/tree/tests-unit_with_ffi) to track my status!
I created a new folder within <code>tests</code> called <code>unit</code>. This is
where my code will live.

First, we need to install
[node-ffi](https://github.com/rbranson/node-ffi) and other required modules.
{% highlight bash %}
npm install ref node-ffi ref-struct
{% endhighlight %}
[ref](https://github.com/TooTallNate/ref) and [ref-struct](https://github.com/TooTallNate/ref-struct) are used to define C types and structs in
JavaScript, respectively.

Now that we have our tools installed, I started a script called
harness.js. This is what I have done so far:
{% highlight js linenos %}
var ref = require('ref');
var ffi = require('ffi');
var StructType = require('ref-struct');

// define types
var voidPtr = ref.refType(ref.types.void);
var webvtt_cue_fn_ptr = ref.refType(voidPtr);
var webvtt_error_fn_ptr = ref.refType(voidPtr);
var webvtt_timestamp = ref.types.double;
var webvtt_cue = ref.refType(voidPtr);
var webvtt_bytearray = ref.refType(voidPtr);
var webvtt_int8 = ref.types.int8;
var webvtt_int16 = ref.types.int16;
var webvtt_int32 = ref.types.int32;
var webvtt_int64 = ref.types.int64;
var webvtt_uint8 = ref.types.uint8;
var webvtt_uint16 = ref.types.uint16;
var webvtt_uint32 = ref.types.uint32;
var webvtt_uint64 = ref.types.uint64;
var webvtt_int = ref.types.int;
var webvtt_char = ref.types.char;
var webvtt_short = ref.types.short;
var webvtt_long = ref.types.long;
var webvtt_longlong = ref.types.longlong;
var webvtt_uint = ref.types.uint;
var webvtt_uchar = ref.types.uchar;
var webvtt_ushort = ref.types.ushort;
var webvtt_ulong = ref.types.ulong;
var webvtt_ulonglong = ref.types.ulonglong;
var webvtt_byte = ref.types.uint8;
var webvtt_bool = ref.types.int;
var webvtt_length = ref.types.uint32;
var webvtt_status = ref.types.int;

// define structs
var webvtt_parser = StructType({
  state: webvtt_uint,
  bytes: webvtt_uint,
  line: webvtt_uint,
  column: webvtt_uint,
  read: webvtt_cue_fn_ptr,
  error: webvtt_error_fn_ptr,
  userdata: voidPtr,
  mode: webvtt_bool,
  finish: webvtt_bool,
  flags: webvtt_uint,
  cue: webvtt_cue,
  truncate: ref.types.int,
  line_pos: webvtt_uint,
  line_buffer: webvtt_bytearray,
  tstate: webvtt_uint,
  token_pos: webvtt_uint,
  token: webvtt_byte
});
// create binding to libwebvtt
var libwebvtt = ffi.Library('./libwebvtt.a', {
    'webvtt_parse_chunk': [ webvtt_status, [webvtt_parser, voidPtr, webvtt_uint] ],
    'webvtt_finish_parsing': [ webvtt_status, [webvtt_parser] ],
    'webvtt_parse_cuetext': [ webvtt_status, [ webvtt_parser, webvtt_uint ] ]
  });


console.log("Reached end!");
{% endhighlight %}
Starting at the top, we include our node modules. I wish a dependency
system was built-in to JavaScript but npm and node do the job in this
context. Next, using the ref module, we define a bunch of different
types. This would be the equivalent of writing <code>typedef</code>
statements in C/C++. You can see in the 
[util.h](https://github.com/humphd/webvtt/blob/seneca/include/webvtt/util.h)
of our parser that we typedef many primatives in order for the code to
be portable across platforms. I'm not 100% sure if I'm implementing the
types correctly on the node-ffi side, though. For instance, I'm not sure how enumerations should be
handled. Right now, I am treating them as integers. I figure this would
translate well to C enums. I believe you can also use pointers by calling
<code>.ref()</code> or <code>.deref()</code> on pointer type variables
to reference or dereference it.

I defined one structure with ref-struct so far, the webvtt_parser struct.
However, I'm not sure if this is necessary. I believe I may be able to
use void pointers in place of structs with node-ffi. This is something
I'm going to have to experiment with.

Line 56 contains the real meat of node-ffi. This is where we create our
binding to the C library. The <code>Library</code> method will takes a name of the
library, and a dictionary of arrays containing information about the
library's API. For each method, we define: the method's name, its return
type, and a list of the types of arguments taken.

At this point, running the program will throw an error. The library we
referenced in the Library method, 'libwebvtt', cannot be found! From
what I understand, node-ffi requires either a dll or so file to link to.
So my next goal is to compile a shared object file, or so file, from our
libwebvtt code. Humph gave me a temporary solution for now, being a
commaand to compile a shared object file:
{% highlight bash %}
gcc -dynamiclib -undefined suppress -flat_namespace \
obj/development-10.8.0-i386/libwebvtt/alloc.o \
obj/development-10.8.0-i386/libwebvtt/bytearray.o obj/development-10.8.0-i386/libwebvtt/cue.o \
obj/development-10.8.0-i386/libwebvtt/cuetext.o obj/development-10.8.0-i386/libwebvtt/error.o \
obj/development-10.8.0-i386/libwebvtt/lexer.o obj/development-10.8.0-i386/libwebvtt/parser.o \
obj/development-10.8.0-i386/libwebvtt/string.o -o libwebvtt.dylib
{% endhighlight %}
Does this work? Will I be able to create a node-ffi binding after this
step? Stay tuned for the thrilling middle of this story!
