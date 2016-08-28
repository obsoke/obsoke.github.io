---
layout: post
tags: [open-source, git, terminal]
date: 2012-10-01 21:00:00
title: Supercharge your terminal with magical Git powers!
---
I love working in the terminal. The mouse? Bah! Who needs it? Just give me a nice mechanical keyboard and I'll be happy. I've been using a neat terminal trick for a while that makes working with Git branches a lot easier. I didn't come up with this trick, but I love it so much I thought I'd share it with everyone else.

<a href="http://i.imgur.com/NS629.png"><img src="http://i.imgur.com/NS629.png" title="Hosted by imgur.com" alt="My terminal." /></a>

This is where I spend a lot of my time. This is [iTerm 2](http://www.iterm2.com/) for MacOS X using the [Solarized Dark](http://ethanschoonover.com/solarized) theme by Ethan Schoonover, if you were wondering. The important thing to note is the little **master** text in square bracketes to the right of my present working directory. This tells me what git branch I'm working on. You can see nearly at the bottom that when I switch out of a directory with a git repository, the branch status text disappears. When I switch branches, the status text is updated to reflect that. If the branch has uncommitted changes, an asterisk appears beside the status text.

This is all done through some bash scripting trickery. I don't quite understand it myself; I took the code from this amazing [dotfiles repo](https://github.com/mathiasbynens/dotfiles) by Mathias Bynens. His original code can be found in his [bash prompt](https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt) file. Hopefully this will help make working with many branches in Git less disorienting!
