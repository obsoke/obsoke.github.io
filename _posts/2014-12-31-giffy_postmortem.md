---
layout: post
title: Giffy&#58; A Postmortem
tags: [open-source, giffy, projects, postmortem]
date: 2014-12-31 17:05:00
---
I've recently finished up a small side project that I started quite a
while ago called [Giffy](http://giffy.dale.io). It wasn't a particularly large or complex
project but the motivation to continue working on it diminished
shortly after starting. Now that the project is done, I wanted to
write a post discussing some of the challenges I faced and thoughts I
had.

### On Side Projects

Working on a side project is a great way for any developer to learn
about a new technology, further develop an existing skill or just get
some creative juices flowing. However, I've found it much easier to
start a project than to actually finish one. There can be many reasons
why finishing a side project can be hard. For Giffy, those reasons
were feature creep, scope and changing personal thoughts on images on
the web. While side projects can be a great place to experiment, too
much experimenting led to a feature list that was much too long. This
can be mentally draining when done close to the beginning of a
project. I wouldn't recommend it. I've learned a lot about looking at
a feature and breaking it down into smaller features. Working in
smaller chunks makes it easier for me to focus on the current
objective and to experience the thrill of seeing a feature come to
life more frequently.

### What is Giffy?

Giffy is simply an image hosting service for gifs. You can tag gifs
that has been uploaded, and find similarly tagged gifs. If you don't
have any gifs to upload, you can create one in the browser using your
webcam. Once you've created your gif, you have the option to upload it
directly to Giffy.

Some features, such as adding & deleting tags, require an account. One
of the features I ended up cutting was a permissions system that would
let the admin define roles and associated permitted & forbidden
actions (eg: upload a gif, delete a tag). Bits and pieces of the
permissions system exist in the code, but it was never finished.

There were a bunch of social-networky features I cut from the feature
list. I had to step back and remember what my goals were for this
project:
1.  Learn more about Angular
2.  Learn how to upload images directly to an Amazon S3 bucket from the
    browser via CORS
3.  Learn how to create a gif from a webcam using WebRTC and upload
    that gif directly to S3

Here on the other side of the project, I feel that I've completed
these goals. Learning not only how to cut unnecessary fat from the
feature list, but also how to divide my main tasks into smaller, more
manageable sub tasks was important to keep me going towards the finish
line. Focusing on the important features to cut can be hard in a
project that exists solely for learning and experimenting, but for
some people it may be necessary if that project is ever going to see
the light of day.

### The Backend

There is not a whole lot of magic happening on the backend. All it is
really doing is serving HTTP requests and fetching data from the
database. I'm using the [Bookshelf ORM](http://bookshelfjs.org/) to handle all things database,
backed by Postgres. It's a pretty nice ORM that makes mapping models
to database tables incredibly easy. While I found that it lacked some
basic features such as limiting the amount of rows returned, it's
possible to use the underlying [Knex.js](http://knexjs.org/) library to perform raw SQL
queries. Other libraries I use are bcrypt for password salting,
shortid to generate a unique file name for gifs and Amazon's AWS
library for Node.js

In terms of design, I make heavy use of promises instead of callbacks
in my API code. Promises are very easy to use and, in my opinion, make
ones code much more readable (goodbye, callback hell).

One design choice I regret is choosing session-based authentication
over token-based. The way I originally designed the application was a
standalone API that would be able to handle requests by clients on any
kind of device. I ended up with more of a Rails-type monolithic app so
cookie-based sessions were pretty easy to implement. From my limited
understanding, cookie-based authentication doesn't work very well on
mobile devices. A much simpler solution would be to include a token
that identifies the user with each request. Ah well, lesson learned
for my next side project!

### Angular

It really bothers me that I need to use a [plugin](https://github.com/angular-ui/ui-router) for a framework just
to do something as simple as nested views. I feel like a framework
that focuses on building single-page apps like Angular should have
this built in. Perhaps I'm being nit-picky but it's a design choice I
find baffling. Also, the way Angular differentiates services,
factories and providers is a little strange and seems arbitrary.

Aside from those points, using Angular has been mostly painless and
made developing the web app portion of Giffy easy. I don't think I was
pushing the limits of the framework or anything. Most of the
challenges I faced came with getting sessions to work between Angular
and Express, or routing static assets; nothing specific to Angular
compared to other single-page app frameworks.

In the end, I was mostly pleased with Angular, and would consider it
in future projects.

**EDIT (2015-01-17):** After some consideration, I'm not too sure if I
  would actually use Angular for another personal project. I'm not a
  huge fan of how Angular 2 is looking.

### Direct to S3 Upload

One feature I really wanted in Giffy was the ability to upload a file
directly to an Amazon S3 bucket directly from the browser. I wanted
the API behind Giffy to solely handle requests and to fetch the
appropriate data from the database. I found [an article on Heroku's dev
centre](https://devcenter.heroku.com/articles/s3-upload-node) on the subject, which makes use of Amazon's AWS library for
Node.js. The library is used to create the proper signature for the
upload request, which contains information like where in the bucket to
put the file, expected file size, and authentication to the
bucket. Once the image is successfully uploaded, a call to the API is
made to register the newly uploaded gif in the Giffy database.

The Heroku article also included a link to a [client-side S3 uploading
script](https://github.com/flyingsparx/s3upload-coffee-javascript). I quickly ran into some limits with the script though, such as
not getting as much metadata as I would have liked about the file with
the upload completion callback, or not supporting the ability to
upload a binary image blob to S3. I ended up forking the repo and made
the necessary adjustments, which you can find [here](https://github.com/obsoke/s3upload-coffee-javascript).

While this solution is novel, I kind of regret designing it this
way. This has to due with how I now feel about gifs in general. Gifs
can cause unnecessary repaints in some browsers, which can greatly
affect performance. For Giffy, where I could potentially have a page
full of gifs, I was worried that performance on some older desktop and
laptops or mobile devices would suffer.

There have been some interesting ways of solving this problem. For
instance, Twitter [converts gifs to mp4](http://blog.embed.ly/post/89265229166/what-twitter-isnt-telling-you-about-gifs) and shows users the video file
instead. I thought this was a pretty neat solution. Not only will a
mp4 file be much smaller than the average gif, but the user also gets
control over the playback of the image. This is most likely the
solution I would have chosen for Giffy as well. However, since Giffy
uploads the image directly to S3, it wasn't feasible for this
iteration of the project. If I decide to return to the project, it
would be the first thing I would change.

### Create gif from webcam

The final feature I wanted to implement was the ability to use one's
own webcam to create a gif. When I was working as a contractor for
Mozilla Webmaker last year, this was an idea the frontend team played
around with for the Webmaker Profiles feature. I thought it was fun
and decided to implement it into Giffy.

My implementation is pretty simple. The creation of gifs is done by
capturing frames via button click. I found a [gif encoder written in
JavaScript](http://jnordberg.github.io/gif.js/) that I use to create the gifs. When one clicks the
\`Capture\` button, the current frame displayed in the video tag is
copied pixel by pixel to a canvas. The image data stored in the canvas
is used by gif.js to create one frame of the gif. gif.js uses web
workers to create the gif in the background, leaving the interface
responsive.

For one crazy second, I actually considered writing my own gif encoder
in JavaScript. It would have been an interesting project, but way out
of the scope for Giffy. Other things I would have liked to add would
have been some tacky Instagramish filters and the ability to record a
gif for N seconds, rather than having to add each frame manually.

### Final Thoughts

Some other features that were cut from the list were allowing users to
add gifs to a favourites list, unit tests, and allowing user
comments. The ability to search by tag was another feature I cut. In
retrospect, none of these features would be particularly difficult to
implement at this point but you have to draw the line somewhere on
some personal projects or they will never end. There are other
potential projects that I am currently more interested in spending my
time on.

I learned quite a bit from working on Giffy. Aside from the numerous
technical and design lessons I learned, the lessons about scope and
feature creep are what really hit me: breaking big features up into
smaller ones and setting attainable milestones that end with some
feature that can be demonstrated in at least a small fashion. Working
on Giffy one huge feature at a time made it feel like a chore, but now
that it's finally over, the satisfaction of putting the 'Complete'
label on a project makes it all feel worth it. Kinda weird how that
happens.

Feel free to check out the source code [on my GitHub repo](https://github.com/obsoke/giffy). A [demo of
Giffy](http://giffy.dale.io/) is also available. I'll be writing a cron script to clean out
the database & S3 bucket every few days. Please don't abuse the demo
site! Feel free to fork, open pull requests, or leave feedback!
