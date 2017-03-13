---
title: Automated Publishing Pipeline with Org Mode
layout: post
tags: [org, emacs]
header: 2017-03-12-header.png
headertext: This very blog post being written - in Org mode!
---
I have some files written in Org that I want to publish & upload to a web server every week at a set time. Why? I'd like to be able to view my notes from anywhere, and others may stumble upon them and find them useful. However, I don't want to have to remember to publish & upload everytime I make change to these files, and I want this to occur with as little user interaction as possible.

To accomplish this, I'm going to make use of Emacs [Batch Mode](https://www.emacswiki.org/emacs/BatchMode). Batch Mode will run Emacs in a non-interactive fashion; you feed it a file or an Elisp function to run, Emacs does its work and then exits without displaying a window. [ox-twbs](https://github.com/marsmining/ox-twbs) is an Emacs package I'll be using to export my Org files to [Bootstrap](http://getbootstrap.com/)-themed HTML.

The project I want to set up will be a couple of files that will act as a log of the things I have accomplished each week, goals for the next week and any associated notes or links I'd like to record. I'm going to create a directory for this project at `~/org/log` and create a couple of files: `index.org` will just contain a link to our second file, `2017.org`. `2017.org` will contain a descending-order list of the weeks of the year with associated notes using the following structure:

```
* Week 11 (March 13 2017)
** Recap
** Next Week
* Week 10 (March 6 2017)
** Recap
** Next Week
```

By default, Org mode will create a full table of contents for the page, complete with the headlines being numbered. I'd like to avoid this: I only want to see up to the second level headlines in the table of contents and nothing below. Additionally, I don't want the headlines to be numbered.

Thankfully, I can easily specify all of these settings in one place by defining a **project** in Org mode. By defining a project, we can easily generate HTML for our project with one command: `(org-publish-project "PROJECT_NAME")`. A variable called `org-publish-project-alist` is used to define any number of Org projects one may have.

The first thing I want to do is create a new Elisp file that will be used to import needed packages, define any required variables, and run the necessary function to build the site. Since I use Spacemacs (which has a fairly high amount of modules to load), the only modules I want to load are the bare minimum required to get Org running so Emacs can do its business. Inside `~/.emacs.d/`, I create a new file called `org-export.el` with the following contents:

```elisp
(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-publish)

(setq user-full-name "Dale Karp")
(setq user-mail-address "dale@dale.io")

(setq org-publish-project-alist
      '(("my_log"
        :base-directory "~/org/log/"
        :publishing-directory "~/projects/site/log"
        :publishing-function org-twbs-publish-to-html
        :section-numbers nil
        :table-of-contents 2)))


(org-mode)
(org-publish-project "my_log")
```

First, I import some packages and set some variable such as who the author will be (me!). Next, the Org project gets defined within `org-publish-project-alist`.

I define a single project called "my_log" with some options. Some of these are self-explanatory: `:base-directory` tells Org where to look for the files - any `.org` file in this folder will be processed. Since I'll be publishing this to a subsection of my website, I've set the `:publishing-directory` to the right location. Because I'm using `ox-twbs` to generate our HTML, I need to tell Org to use it when publishing instead of the built-in HTML exporter. Finally, I let Org know that I don't want any sections to have numbers, and that I only want our table of contents to have links for level 2 headlines and above.

Now that our publishing pipeline is ready, I need to set up the 'automation' part. I host my site on GitHub Pages, so all I need to do to build my site is to create a new Git commit in my site repository after publishing, and pushing that commit to GitHub. To do all of this, I'll write a Shell script! Because I'll be a systemd timer to run this script at a set interval once a week, I need to set up a few things like retrieving SSH keys for the session so I can push to GitHub without being prompted for a pssword.

```sh
#!/bin/sh

# load ssh keys from keychain for this session
eval $(keychain --eval --quiet --noask id_rsa)

# call & run our exporter elisp script
emacs --batch -l ~/.emacs.d/orgexport.el

# change directory to our repo
cd ~/projects/site

# commit latest changes
git commit -am "Log for: $(date)"

# push commit to get built on gh pages
git push
```

With the script written, the last thing to do is to use a scheduler to run it every week. I'm using systemd's timers to do this, but cron should work as well. I created two files in `~./config/systemd/user` with the following contents:

```sh
# mylog-org-export.service
[Unit]
Description=Exports Org project "My_Log" and pushes Git to GH Pages

[Service]
ExecStart=/home/dale/.bin/org_upload.sh
```

```sh
# mylog-org-export.timer
[Unit]
Description=Run mylog-org-export.service every Monday at midnight.

[Timer]
OnCalendar=weekly
Persistent=true
Unit=mylog-org-export.service

[Install]
WantedBy=timers.target
```

Now I can test to make sure our timer works and once verified, enable it:

```sh
systemctl --user start mylog-org-export.service
systemctl --user enable mylog-org-export.timer
```

Verify that the timer is active with `systemctl --user list-timers`, and we're good to go!

At this point, I have an automated Org publishing pipeline that will convert our Org files to HTML once a week and then push the new data to GitHub pages to built. This approach can be customized fairly easily to publish anything from project documentation to a personal blog. If you have any suggestions on how to improve this or have any alternative methods, please let me know!
