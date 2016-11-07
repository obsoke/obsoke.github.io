---
title: A Rusty Venture&#58; Writing a text adventure in Rust
layout: post
tags: [rust, gamedev]
header: 2016-11-07-header.png
headertext: A scene of 'thrilling' gameplay in Adventure.
---

After a couple of months of playing around with Rust, I've finished a project!
It's a simple text adventure game in the vein of class text
adventure [*Zork*](https://en.wikipedia.org/wiki/Zork) called *Adventure!*. The
feature set isn't as wide as Zork; there is no combat and movement & world
interaction is pretty simple. I was never really into text adventures myself,
but I though that it would make an interesting & fun first project with Rust.

### Design

I wanted to write a game containing of a few rooms, with a few things to do in
each room. The feature set wouldn't go past picking up objects, adding them to
an inventory, and using inventory objects with static objects in the world. I
didn't want to involve combat on NPCs as I didn't want to work on this project
for the long-term; it's a toy project for learning a bit about how Rust works.

### Changing Rooms

My first design involved having `Room` structs that would contain a member
`connection: Connection`. This `Connection` struct would itself have 4 members:
`north`, `south`, `east` and `west`. The value of these members was to be an
`Option<Box<Room>>`. The main `Game` object that ran the whole show would have a
`current_room` reference that points to whatever instance of `Room` the user was in.

Unfortunately, this design gave me trouble with the borrow checker. I got many
`cannot moved out of borrowed context` errors thrown at me. At the time, I
didn't really fully understand how the borrow checker works - and honestly, I'm
pretty sure I still don't understand fully. I decided to take a simpler
approach: I'd store `current_room` as an integer representing an index in the
vector of rooms. In Rust, the index of a vector is the type `usize`, a
pointer-sized (therefore system-dependent) unsigned int. At first, I stored
`current_room` as an `i32` but this led to lots of `as usize` casting all over
the place. `Connection` objects would be `Option<usize>` and changing rooms
would be as simple as replacing `current_room` with another `usize` value.

The downside of this approach is having to know each `Room`'s index in the
vector ahead of time. I kept track of the room number while designing the game
'map' so it wasn't a big deal in my particular situation. I thought being able
to 'point' to other `Room` directly with a reference would be simpler, but that
would bring its own problems with it. For example, this would bring about
circular references (eg: Room 1 is connected to Room B, but if we create Room 1
first, how do we define this relationship when creating the `Room` object? My
solution: You wouldn't, you'd connect the rooms afterwards).

### Flags & Actions

My next set of problems came with dealing with state change in the game. I ended
up declaring a `HashMap<&'static str, bool>` in a struct `Flags` at the
top-level of the game that gets passed around to the different functions.
Originally, each `Room` was going to have its own set of flags but I didn't want
have to reach across rooms to check the state of something - especially if an
action in one room can have consequenes elsewhere.

Dealing with the actions took the longest to figure out. I had an important
questions I needed to answer at this point: How can I define each `Item` or
`Room` to have different behaviour depending on the state of global flags? To
solve this, I used closures. For instance, here is how an `Item` is defined:

```rust
struct Item {
    name: String,
    is_grabbable: bool,
    on_grab: Box<Fn(&mut Flags)>,
    on_use: Box<Fn(&mut Flags, String, usize) -> bool>,
}
```

Both `on_grab` and `on_use` accept closures. Because our state is stored in a
global object, each room doesn't really need to worry about what's going on in
other rooms - they only need to know the state of the world through the `Flag`
objects they receive. This allows me to use closures to define certain
behaviour.

I'm not exactly sure if this method is idiomatic Rust. I've been writing
primarily JavaScript for my day job for the past few years so I'm still in that
state of mind where functions are first class citizens that I should be taking
advtange of. I wasn't really sure how else to define individual behaviour for
separate instances of the same type.[^1]

For instance, this is an example of how an `Item` is defined:

```rust
Item {
    name: "shovel".to_string(),
    is_grabbable: true,
    on_grab: Box::new(|flags: &mut Flags| {
        println!("The shovel looks as if it has never been used before; the layer of dust that falls off as you pick it up shows that it has been sitting on that table for a long time. You slip the shovel in your pocket.");
        flags.update_key("pickedUpShovel", true);
    }),
    on_use: Box::new(|flags: &mut Flags, object_name: String, current_room: usize| -> bool {
        // this sucks; checking if we are in the room before perfoming action
        if current_room == 1 && object_name == "glass door" {
            if flags.get_key("smashedDoor") == Some(&false) {
                println!("It takes a few swings before a couple of cracks appear in the glass. Wondering why such strong glass is needed for a greenhouse door, you continue to swing away until a loud crash and gust of fresh air announces the success of your swinging endeavours.");
                flags.update_key("smashedDoor", true);
                false
            }
            else {
                println!("You seem to have already done a number on that poor door - maybe you should leave it alone?");
                false
            }
        }
        else {
            println!("You aren't sure how to use the shovel with the {}", object_name);
            false
        }
    }),
}
```

... and that's just **one** item! Imagine a whole `Room`, with it's own
behaviour and items! (Or see for yourself and
[check out the source file with the levels defined](https://github.com/d10p/adventure/blob/master/src/levels.rs)).

Another issue is that this method leads to cases where certain objects that don't use a specific
callback have empty closures, which makes `rustc` complain about unused
variables. This isn't a huge deal, but it can clutter up compiler messages which
is slightly annoying.

Originally, I planned on serializing each room into data files instead of hard
coding them into Rust source code. This way, anyone can write their own text
adventure without knowing a line of Rust! As soon as I decided to use closures,
however, that task seemed like it would be much more difficult. How do you
serialize behaviour? The only method I can think of is via a scripting language,
and that was way out of scope for this project.

### Other random notes

* It would be nice if there was a way to initialize a `HashMap` by passing a
  series of key/values to its `new()` function or via a literal. I'm using
  a
  [macro I found on StackOverflow](http://stackoverflow.com/questions/27582739/how-do-i-create-a-hashmap-literal) to
  do the job right now but it would be neat if this was built into the standard
  library.

### Conclusion: I like it.

In the process of writing this post, I've had to question a few of my design
choices and actually learned new stuff (the idea of changing the type of
`current_room` from `i32` to `usize` happened due to this post)!

The likelihood of me continuing to work on this project is low. Howevever, if I
were to make an 'Adventure! 2.0', I'd make the following changes:

* Spice things up with Termion. I came
  across [this great blog post](http://ticki.github.io/blog/making-terminal-applications-in-rust-with-termion/)
  by the author of the `termion` crate, ticki. Maybe making some item names show
  up in Zelda's "Important Noun" red, or having more of a persistant GUI on
  screen such as the inventory.
* Take advantage of more core Rust/Cargo tools, like rustdoc.
* Tests! Testing is important. I worked on this project for a few hours a week over the span of a month so it wasn't something at the top of my mind.
* Figure out cross-compilation so I can build executables for Windows & MacOS from my Linux desktop

I had fun working on Adventure. If you'd like to check it
out, [here is the GitHub repo](https://github.com/d10p/adventure). I'd like to
figure out cross-compilation soon to get some binaries up on on the GitHub page.
My next project will involve *gasp* graphics! Until then...

[^1]: As I write this, a few ideas come to mind (although I'm not sure if they actually work). Perhaps creating a trait that all `Room`s/`Item`s implement, and write a macro that creates a new struct with said trait with the individual behaviour defined within? Just a thought.
