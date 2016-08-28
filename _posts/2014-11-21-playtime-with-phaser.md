---
title: Playtime with Phaser
layout: post
date: 2014-11-21 7:30
tags: [gamedev]
---
For the past few days, I've been playing around with [Phaser](http://phaser.io/), a game engine written
in JavaScript. I decided that I'd like to experiment with game development for the next month. It has been
a career path I've considered on and off throughout my life, but I need to put the idea to the test: do I
actually **want** to make games, or do I just find the thought of doing it appealing? Let's find out!

### Struggle of Inaction
A lot of new game developers (including myself) seem to fall into a trap.
Do you want to make a game, or do you want to learn how to program games through engines? My problem was that I was
obsessed with the idea that I had to start out learning how it all worked from the lowest level. "If I use an engine,"
I would think to myself, "and it limited my grand ambitious game, whatever would I do?!" I would then attempt to learn OpenGL,
get frustrated trying to tie everything together into something that resembles a game and give up.

The fear of using an engine without fully understanding how games work was a huge concern, although I don't know why. I don't understand how my car works
but that doesn't stop me from using it. I think I was partially making excuses to justify the [Not Invented Here Syndrome](http://en.wikipedia.org/wiki/Not_invented_here#In_computing)
I was experiencing. If I really want to make games, an engine is probably the best place to start. When I run into issues due to gaps in my knowledge, I'll just
fill those gaps in as I need to.

### Select your Engines
With a renewed sense of resolve, I now had to choose a language and engine to work in.
I decided that my first project would be a simple platforming-style game so heavy engines like Unreal
or CryEngine seemed a bit over-the-top. [Unity](http://unity3d.com/) is another very popular engine with indie and hobbyist developers,
and has the ability to export your game to a variety of platforms. In the end,
I felt forced into using their GUI app to get stuff done. I'm just not a big fan of using mice!

It had been a few years since I last looked at JavaScript game engines. Back then, audio on the web wasn't well-supported. The [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)
is now here but still doesn't have full browser support (looking at you, IE). Regardless, I feel like JavaScript speed increases, audio API improvements and the growth of the JS game development community has made this a good time
to try out writing a game in JavaScript.

There are quite a few mature JS game engines around, such as [MelonJS](http://melonjs.org/), [ImpactJS](http://impactjs.com/), and [Phaser](http://phaser.io/). I ended up choosing Phaser for a few reasons:

1. The Website looked good (Hey, what can I say, this actually matters to me)
2. Excellent [examples site](http://examples.phaser.io/) and [documentation](http://phaser.io/). These two were fairly important in my final decision. The examples site contains many (you guessed it) examples
of different ways to implement everything from animation via spritesheets, using the camera, music and more. I'm a learn-by-example kind of person, so this was perfect for me. The documentation is pretty great,
and the source code itself is well commented and easy to understand.
3. Price & license. ImpactJS costs $99USD for a license. While you receive the source code with your download, you can't contribute upstream from what I understand. Both MelonJS and Phaser are open source under the MIT license.
I'd prefer to use an open source engine if I could, as I'd like to contribute any bug fixes I may come across with the engine itself.
4. Built-in support for levels created with [Tiled](http://www.mapeditor.org/), a tile-based map editor. This wasn't a huge deal but it is nice to have.

Both Phaser and MelonJS seemed equally capable. I found more questions asked on StackOverflow on Phaser (287 vs MelonJS's 47 as of this post). While questions on StackOverflow isn't the greatest metric to judge an engine on,
I just wanted to make a quick choice and this shallow justification did the job.

### Initial thoughts & issues
Now that I had my engine chosen, it was time to get started. This is where I encountered my first roadblock: I had no art. I needed some tilesets and character sprites to start off with.
Luckily, there are plenty of freely licensed artwork packs available for those of us who are not artistically inclined. One such pack, [Platformer Art Complete](http://opengameart.org/content/platformer-art-complete-pack-often-updated)
is a huge pack of tiles, items, character sprites and more made by an awesome dude named Kenney.

After creating a small simple level with a few platforms, I loaded it into the
engine and noticed that some platform tiles were not the ones I selected to use
in Tiled. The initial spritesheet included in the pack that I was using had some
excess art on the right margin. Spritesheets work by providing the size of each frame
in the sheet, and the amount of rows and columns of frames. So if Tile N is on row 3,
column 3 of the sheet, and each frame is 50 pixels square, then by grabbing the subsection
of the image at x 100, y 100 should get us the desired frame. However, while Tiled
was smart enough to remove the excess tiles from the spritesheet, there is no way Phaser
could possibly know that; it just knows how big each frame is and the amount of frames per
row and column. I found a [version of Kenney's platformer base pack](http://opengameart.org/content/kenney-platformer-base-pack-for-tiled)
that was made to work with Tiled. After using this, my problems went away. When I
attempt to create my own art, I'll be able to specify how the spritesheet is layed out.
Until then, be mindful of your art!

After ensuring the level was being rendering correctly, I added a simple character
with basic move left/right controls. So far, so good. I decided to test out the camera
functions by creating a level larger than the canvas/game viewport of 1280x720.
For some reason, this caused my player sprite to get caught on some invisible walls.
I did some research and found [this thread](http://www.html5gamedevs.com/topic/10517-camerascreenview-is-never-adjusted/) with some else describing a similar issue.
Luckily enough, a Phaser developer chimmed in stating that he found the cause and that
it had been fixed in the dev branch. Thankfully, using the dev version of Phaser
seemed to fix it.

So far, I'm pretty happy with Phaser. Just getting things happening on a screen and
reacting to input is pretty awesome. Hopefully I'll have something to show off in my
next post!
