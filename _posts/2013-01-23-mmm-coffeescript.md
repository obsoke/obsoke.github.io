---
title: Om nom nom, CoffeeScript
layout: post
date: 2013-01-23 14:05:00
tags: [open-source, cdot]
---
From what I understand about the HTML5 client for BigBlueButton,
it is written in CoffeeScript (and Node.js) and uses Redis as a database. That is all I know
as of now! Since the client is being written in CoffeeScript, I figured
it was time to fill in that knowledge gap and do what all the cool developers seem to
be doing: learn CoffeeScript!

### Assumptions

I have heard a lot about CoffeeScript in the past year. It's a language that compiles into
JavaScript. Why use CoffeeScript? Well, it has a syntax style that is similar to Ruby,
which I imagine makes transitioning from Ruby/Ruby on Rails to JavaScript/Node.js much less painless
for the many RoR developers out there.
I thought it would be interesting to write down my initial impressions of CoffeeScript
before actually learning or using it, just to see how my personal biases affect what I
don't know, and how my opinion changes after educating myself. Just a fun little
experiment.

Personally, I'm a bit wary of using CoffeeScript. To me, it seems to place another level
of abstraction between the code you write and the code that ends up being executed. From what I
know about CoffeeScript, it compiles into very clean JavaScript code. However, what if a
bug exists in the CoffeeScript compiler that produces invalid JavaScript every time you
build your code? This may be an example of a unique use case (and probably one that would
be resolved quickly, as CoffeeScript has a large community) but it is a possible problem.

### Learning

Here are some various thoughts I've had while playing around with CoffeeScript. Most of
these have to do with the language itself and my development environment.

* [Nice webpage](http://coffeescript.org), lots of documentation that seems to detail the
entire language including compiler options and syntax
* The ability to try CoffeeScript live in a browser is pretty awesome. However, as we will
be doing serious development with CoffeeScript, so let's set up a serious development environment
* CoffeeScript is a node app. Let's install it so we can access it anywhere (aka: installing node
module as a global module): `$ npm install coffee-script -g`
* I use vim as my primary editor. Vim doesn't support coffee script out of the box, but there is
a plugin which [enables CoffeeScript syntax](https://github.com/kchmck/vim-coffee-script). I use
[Vundle](https://github.com/gmarik/vundle) to manage my Vim plugins (of which you can find
a list of in my [.vimrc dotfile](https://github.com/daliuss/dotfiles/blob/master/vim/vimrc))
* Let's start playing around! `$ v lol.coffee # opening up a test file. alias v=vim`
* At the same time, I'm going to tell coffee script to watch that file and to compile the
.js version in the same directory (in a new terminal): `$ coffee --watch --compile lol.coffee`

Here are more assorted thoughts on CoffeeScript! These ones focus on syntax and other features
of the language:
* Ruby style `if` statements are nice.
* No semicolons needed to terminate statements, and indentation is used to signify blocks...
If I haven't used Python/Ruby before, I would feel very weird and wrong coding like this
in JS.
* Exists operator: follow a variable by a question mark with no white space (eg: `dale?`).
Converts it into `if (typedef dale!== undefined && dale !== null)` to check whether a variable
exists. Very nice!
* Splats: A useful way to work with functions that take an indeterminate amount of arguments
(more intuitive to use than the arguments object).
* Comprehensions: Use almost-SQL-like statements to generate for loops.
* Function definitions **are** easier to do...
* So far, the gist that I'm getting is that CS is great if you know JS at a medium/advanced level
at least. You can do pretty much everything you can do in JS, but with less typing.
* Scoping and variable hoisting are taken care off automatically.. nice!
* Like Ruby, CS returns the final value in a block (doesn't require the use of the return
keyword unless you want to explicitly exit a function/method early).
* `==` gets compiled into `===`, which I find interesting. What happens if you want to check
value equality but not type equality (a weird use case but it could happen). Looks
like CS makes this action quite impossible.
* &#64;property gets compiled into this.property.
* Provides 'class' structure & capabilities.. looks very Ruby-like (this is pretty huge IMO,
as many people, including myself, find JS's prototypical inheritance a bit confusing at times).
* String Interpolation "#{variable} is my name!" vs variable + " is my name!".. much nicer!
* Simple build system called Cake, uses cakefiles.

### Initial Conclusions

I'll admit that CS has some very nice features that makes writing JavaScript a much
cleaner process. I haven't used it enough yet to decide whether the added level of
abstraction makes things more difficult. If one has their development environment
set up correctly (using the coffee compiler to watch/compile your scripts) then I can
see that abstraction becoming more transparent.

I feel like I'm ready to now dive into the current code base for BBB's HTML5 client!
My next post will hopefully consist of me trying to sort through the source code.
Good luck to me! Until then...

