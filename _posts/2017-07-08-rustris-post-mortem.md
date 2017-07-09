---
title: Rustris Postmortem&#58;  Making Tetris with ggez 
layout: post
tags: [rust, gamedev, ggez, sdl2, tetris]
header: 2017-07-08-header.png
headertext: Screenshot from the 2017 GOTY, Rustris
---

You know what game I love? Tetris. An easy game to play but difficult to master
that's been released on every platform under the sun. The game has had a strong
following for over 30 years and it's still going strong. For my next Rust-based
game project, I decided to make my own version of Tetris with basic gameplay
features, a menu screen and game ending states. After a month of working on it
sporadically, I managed to get the project into a state I'm okay with releasing
into the wild (The source code is available
on [GitHub](https://github.com/obsoke/rustris)
or [GitLab](https://gitlab.com/obsoke/rustris)). Here are some of my thoughts on
challenges faced & choices made during development.

## Goals

The main goal of this project was to learn how to create Tetris in Rust. It was
*not* to learn how to make a game engine in Rust. If I had wanted to do that, I
would have started with something like SDL2 and worked off of that.

## Making Good Games Easily

After spending some time earlier playing around with the
Lua-based [love2d](https://love2d.org/) game framework, picking a Rust framework
influenced by love2d seems like the obvious path to
take. [ggez](http://ggez.rs/) fits the bill here, providing easy ways to draw to
the screen, play audio, access the filesystem, render text, handling input and
deal with timing. It doesn't aim to provide every feature one can want in a game
engine such as entity-component systems or math functions; this functionality
can be provided by already-existing crates. Instead, the focus is on being easy
to get up and running, and to be productive quickly without having to think
about lower level operations. Just like the name of the framework says!

Personally, I found ggez quite pleasant and easy to work with. Much of ggez
revolves around the `EventHandler` trait. This trait contains required callbacks
that must be implemented (`update()`, `draw()`) as well as a bunch of optional
input-related callbacks. From there, a developer has free reign to do whatever
they please.

As an example, this is what my `GameEndState` struct looks like:

```rust
pub struct GameEndState {
    request_replay: bool,
    request_menu: bool,
    request_quit: bool,
    options: Vec<Option>,
    current_selection: usize,

    game_end_text: graphics::Text,
    final_score_text: graphics::Text,
    final_line_text: graphics::Text,
    final_level_text: graphics::Text,
}
```

The input system in Rustris is state-based instead of event-based so for smaller
states such as the game over screen, I store a bool for each potential input
response from a user[^1]. In the state's `update()` method, I check whether any
of these switches have flipped and act accordingly. Options were abstracted into
an `Option` struct, so I store a vector of those as well as the currently
selected option. Finally, when the `GameEndState` is created, so are any
`graphics::Text` objects that are required to display some information on
screen. These are stored in the state and drawn to the buffer every frame.

The simplicity of ggez's API allowed me to just focus on making the game. Each
state contained what it needed to do its job and that's it. Whenever I found
myself repeating code across states, I'd lift that code into a module containing
code shared between states. For example, my `Option` struct which is used across
multiple states (`MenuState`, `GameEndState`), is in `shared` module. It feels
very simple and clean as well as easy to extend later on.

## Bumps in the Road

Once work on the main 'play field' state was finished and plans for the menu
state began, I had noticed a couple of limitations:

1. I had created a `Transition` enum listing potential transitions between
   states within a state manager. I wanted to have both `update()` and `draw()`
   return said `Transition`[^2] so a state's `update()` method can request state
   changes but the ggez `EventHandler` trait is hardcoded to return an empty
   tuple.

2. What if I wanted to create an `Assets` object that held all my assets that
   lived at the top-level of my object hierarchy? This way, a reference to that
   object can be passed to any active states that may need access to an image,
   or a sound. 

3. If `Transition` was defined in my code, how would `EventHandler` even know
   about it? This is when I first jumped into the ggez `event` module source
   code in attempts to make the return type generic. This ended a rabbit hole
   filled with `Box`es and eventually, failure.
   
Thankfully, ggez is written in a clean and modular way - no spaghetti here. I
was able to simply make my own copy of the `event` module and make my needed
changes. I think ideally, there would be a way to define return types from
`EventHandler`from the framework user's end but for now, this will do. The
problem of passing `Assets` seems like a harder one to solve. I don't believe
Rust currently has the option to call functions with a variable number of
arguments or optional arguments. For now, editing the `event` module will work
as a solution.

## Other stuff

Another issue I had actually has to do with one of ggez's
dependencies. [rodio](https://github.com/tomaka/rodio), created by master crate
creator tomaka. Currently, it doesn't have a way to stop any audio that is being
played. There is a PR ready to be merged into implement this, and then ggez
simply needs to offer a high-level interface to stop audio[^3]. This isn't a
huge deal, but it will be nice to have this functionality when it is finally
implemented.

The design for both the `Assets` struct and `Transitions` enum were shamelessly
inspired by the Rust-based [Amethyst](https://www.amethyst.rs/) game engine,
another excellent project. It has tons of great ideas and I'm excited to start
playing around with it in the future on larger projects.

I implemented a state manager inspired by the "Pushdown Automata" discussed in
the "State" chapter of the excellent
[Game Programming Patterns](http://gameprogrammingpatterns.com/state.html). I
believe that Amethyst also uses a similar pattern which makes sense if my
`Transition` enum, used to transition between game states, was inspired by
Amethyst's `Trans` enum. With a state stack, all one needs to do to add a 'pause
state' or 'inventory' screen' is to push that state on the stack when needed and
pop it off when done.

I'm not an artist nor a musician, so I had to rely on open source and freely
licensed assets. All the audio and sound effects were found online and some of
the assets I made, such as the black hole graphic on the menu and the background
of the play field. It's not the best looking or sounding game in the world but
for what was an educational non-commercial product, I think it did the job.

## Final Thoughts

Tetris is a fun game to write in Rust. I don't think that my code is some kind
of incredible work of art, a standard that other code should be judged against
(if anything, it's probably the opposite) but I had lots of fun and I learned
quite a bit about making games, making games in Rust and Rust itself. That was
my goal, so mission accomplished! You can check out the source code
on [GitHub](https://github.com/obsoke/rustris)
or [GitLab](https://gitlab.com/obsoke/rustris). I don't have access to a Windows
or Mac right now so I unfortunately cannot produce any binaries to distribute
this at the moment.

ggez is a great framework to use for small 2D games. I was able to talk with
Icefox, one of the library authors, at the
[Game Development in Rust](https://air.mozilla.org/game-developement-in-rust/)
meetup in Toronto on July 7th 2017. He's a nice & smart guy and after watching
him talk about the future of ggez during his presentation of the framework, I
have 100% confidence that it will continue to grow into a ~~fine young lad~~
great framework to use to make good games easily.

[^1]: For states with more input such as my `PlayState`, I threw all the
    potential state `bool` into its own struct - makes the code easier to read,
    in my opinion.
[^2]: Wrapped in ggez's custom `Result` type, `GameResult`.
[^3]: Yes. Just "simply" implement it. You know, easy!
