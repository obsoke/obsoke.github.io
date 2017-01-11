---
title: Jump Around
layout: post
date: 2015-02-27 18:30
tags: [projects, open-source, postmortem, gamedev]
---

A few months ago, [I wrote a blog post](http://dale.io/2014/11/21/playtime-with-phaser.html) about my experience playing around with the
Phaser game engine. I ended up making a short 2D platformer game
called [Jump Around](http://lab.dale.io/games/jumparound/). I've uploaded
[the source onto GitHub](https://github.com/obsoke/jumparound) for
those who are interested in taking a peek.  It was a great experience
in which I learnt quite a bit, so without further ado&#x2026;

### Initial Design & Scope

My initial goals for the project were pretty simple:

1.  Make a short 2D platformer game.
2.  Each level would fit on the screen; no camera work needed.
3.  Don't focus too much on making the 'cleanest' code possible on this
    project. This is more getting a feel for game development again.

I wanted to keep things pretty simple, as this project was meant to
not only evaluate Phaser for future projects but also getting my feet
wet with some simple game design. It seems almost like a rite of
passage nowadays for game developers to make a 2D platformer, so I decided to go
for that. Jump Around is inspired by platformers such as Super Meat
Boy, where the emphasis is on pixel-perfect platforming as quickly as
possible. The smaller levels in Super Meat Boy that would fit within
the initial camera frame were always pretty interesting to me. The
small characters moving quickly around an environment in which danger
is visible everywhere made for a strange mix of emotions. Upon
entering a level, I'd both feel terror at the level that I was to get
through, and excitement at the challenge ahead.

I originally scoped for around 6 levels, but I cut it down to 3 as I
came to a realization: good level design is hard work! Once the game
mechanics were implemented, the majority of my time was spent on
figuring out how to be clever with level design. This wasn't my goal
for the project so I decided to cut the level count in half so I could
move on to another project sooner. Aside from that, I feel like I did
a good job with my initial design and didn't end up with much feature
creep. The only feature I ended up missing was using "Jump Around" by
House of Pain as the obvious background music choice. I planned on
distributing the source code for this and I'm pretty sure I would not
have the rights to distribute that song. This is an issue I also had to look
into regarding art I used (gasp, could this be&#x2026; a segue?!).

### Art is hard

Although I have tried many times, I just can't draw very well. This
can be a problem when you are a lone programmer working on a video
game. Thankfully, there are tons of free art resources online. One of
these is the great website [Open Game Art](http://opengameart.org/). I
ended up purchasing a donation-ware art pack from an incredibly
talented & generous artist named [Kenney](http://kenney.nl/). I've
seen him post on [/r/gamedev](http://www.reddit.com/r/gamedev) before,
offering free art packs under liberal license terms for people like me
who aren't so artistically inclined. While this was a decent solution
to not being able to produce art myself, in retrospect I think I
should have kept it simple and gone with a more abstract art style.

As said before, I eventually wanted to release the source of Jump
Around. However, I wasn't too sure about the license to redistribute
the assets. Thankfully, Kenney includes a LICENSE.TXT in his zip of
art which helpfully states that the assets are released under [the liberal CC0](http://creativecommons.org/publicdomain/zero/1.0/)
license. As long as I attribute him, I should be okay to redistribute
the art I used and modified for my purposes.

Most of the audio I use is also from Kenney's donation pack, but the
incredibly ~~cheezy~~ awesome end of level noise that plays was a clip I found off
of [freesound.org](http://www.freesound.org/people/Tuudurt/sounds/258142/). This is another great resource for developers just
looking for simple or placeholder sounds under a variety of
licenses. Thankfully, this asset is also CC0 so the game can be fully
redistributed with all assets intact.

### Resolution is confusing

Another issue I ran into was answering the question "What resolution
am I targeting with this game?" I was making this game for web
browsers running on a desktop. I probably should have consulted the
great [Valve Hardware Survey](http://store.steampowered.com/hwsurvey) to get a sense of what kind of resolutions
people were playing at. While 1920x1080 is the most popular
resolution, it only had 33.48% of user share as of this blog post. In
second place was 1366x768 with 26.80%. I ended up hardcoding my game's
resolution at a very strange and non-standard 1050x714. I did this
because that was the size of my level in tiles (50x24 tiles, as each
tile was 21x21). In retrospect, this was a dumb idea. While I haven't
exactly alienated either of the two largest resolution groups
(according to Valve), it doesn't scale up or down at all. I probably
should have spent more time on making sure the scaling worked; at one
point in development, I found myself even looking at options to use
the [fullscreen API](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Using_full_screen_mode). In the end, I decided to push that learning
exercise to my next project.

Another consideration was "Could this game work on a mobile device?"
Due to the decisions I made based on the art and not bothering to
scale anything, it wouldn't be a great experience. However,
mechanically, it could work. I ended up adding a toggle to cause the
player to continuously jump, and I noticed the game was actually kind
of fun when I left it on. It felt more like "Pogo Around" than "Jump
Around" but it was still fun. I could have left that setting on for
the mobile version and had the user touch either side of the screen to
simulate the left/right cursor movements. Using two fingers instead of
one could make the player run&#x2026; or&#x2026; pogo-run&#x2026; rather than
pogo-walk. In the future, I may revisit this project and try to add
that in, but for now it was out of scope of what I wanted to
accomplish.

If you're interested in trying this 'pogo' mode for yourself, just hit
the F key while playing the game. It adds another layer of
challenge... think of it as hard mode!

### Architecture & Tools

At first, I wasn't really sure how to structure this project. I've
done game development before but never in JavaScript. I found a very
useful blog post called [Building your Phaser Projects with Browserify](http://invrse.co/build-phaser-with-browserify/)
that was helpful in getting the file structure of a game in
place. 

Since the majority of my game objects were simple, I was able to make
to do with simple objects that didn't follow any particular
programming pattern. Some variables, such as current level and overall
game time, were kept in the `game` object, while each state kind of
dealt with it's own area. After the assets are preloaded, the `menu`
state is spun up and waits for user input. After that, the `level`
state is entered. The level state checks what level it should be
loading via the `game` object and starts to create the needed
platforms and tiles.

The levels themselves were created using the fantastic [Tiled](http://www.mapeditor.org/) map
editor. One neat feature of Tiled that I liked was creating
Objects on the map that can store any properties you wish. I ended up
doing this to store quite a bit of data in the level itself, such as
player spawn position, level key position, and starting positions of
moving platforms, as well as their speed, distance and initial
direction. This allows me to use a single state for each level with
little to no code change needed to properly load each level. I feel
like I do cheat a bit by passing the player object through each level
state to retain some data like how many times the player has died, but
it seemed like the simplest solution so I went with it.

Phaser is a pretty nice framework but I ran into some
issues. Currently only a single tile layer from Tiled can be marked as
a collision layer. When Phaser moved from version 1 to 2, it lost some
of it's advanced camera capabilities such as the ability to zoom; I
believe the current camera can only pan by default. Neither of these
are dealbreakers, but they would be nice to have features. I still
think Phaser is one of the best JS engines you can use right now. It
has a decent sized community and there are always people on the IRC
channel willing to help (such as myself!) I've read that Phaser 3 may
be getting a ES6 makeover which makes me very excited for the future
of the engine.

However&#x2026;

### Conclusions

I had a blast making Jump Around, and I'm glad I finished the
project. I learnt quite a bit about a variety of topics. I now have a
huge amount of respect for great level designers, as I spent quite a
bit of time thinking of how to make each level progressively more
interesting. I'm not sure if I've succeeded but I tried to do
something new in each level. I also learnt a bit about 2D animation to
animate the player, audio codecs & conversion to get the sound effects
working, and some basic game design as a result of the project. 

One area that I didn't get to focus on as much as I would have liked was the game
programming itself. I think this is because I used an engine which did
a lot of it for me. Because of this, my next project will most likely
not use an engine at all. I don't want to do everything myself (not
yet at least) so I'll probably use a helper library to handle things
like asset loading, input reading and window creation (if targeting
desktops rather than the web). I plan on reading some of the excellent
[Game Programming Patterns](http://gameprogrammingpatterns.com/) book to get a better feel on how game
architecture works and how things fit together.

So that's Jump Around! Feel free to [try the game out](http://lab.dale.io/games/jumparound/) and [check out the
source](https://github.com/obsoke/jumparound) if you're interested.
