---
layout: post
title: WebVTT and Python Wrestling
tags: [open-source, osd600]
---

### Welcome to WebVTT
The cat is out of the bag: OSD600 will be implementing WebVTT in Mozilla Firefox. WebVTT is a file format primarily used for captioning video. In this case, it will be used in conjunction with HTML5's video tag as a source for subtitles, on-screen text cues or anything related to cueing text to a time. If you're interested in reading the current draft of the spec, you can read it [here](http://dev.w3.org/html5/webvtt/).

### Scriptin' Time
It was early Wednesday afternoon when I got home from school and decided to be productive. I noticed that David Humphrey was in #seneca on MozNet. We started talking and he suggested that I get started on writing tests for the webvtt parser right away. Time was a-tickin', after all (Already week 4… oh boy).

First, he walked me through the process of downloading the webvtt command line parser he wrote in node, using the source from this [open source online WebVTT validator tool](http://quuz.org/webvtt/). First, I had to install node.js, which I did with the handy and awesome Homebrew packaging tool for OS X. Then, following the instructions on Humph's [node-webvtt github page](https://github.com/humphd/node-webvtt), I installed the node module. After that, I was able to run webvtt on the command line. Hooray!

The next step was to create a script to automate the testing process. The idea was to have two directories, one called 'good' and one called 'bad'. Any .vtt files in the good directory should pass the parser with no errors, while files in the bad directory should fail. The test files should demonstrate how different rules of the parser cause some files to pass and some to fail. By having a full test suite, we will have a baseline to implement the actual standard in the browser against. It's actually a pretty good progress indicator. It reminds me of the 'behaviour driven development' style of coding I had to use at my coop, where we used [Cucumber](http://cukes.info/) as the testing framework. 

The test script would gather a list of files in the good and bad directories and automatically run them through the parser. I made a few test .vtt files, the contents of which I copied from samples in the spec or wrote myself. After spending a few minutes playing around with the tool and different scripts, I was ready to start scripting.

I chose to write the test script in Python. I have a confession to make: I know very little Python. I know just enough to get by. Luckily, the documentation for Python is by far the best documentation for a language I have ever seen. I knew that I would need some sort of method to help me navigate through the file system, and that I would have to create an array that contained a list of file system paths to each test file. I stumbled upon the documentation for [os.path](http://docs.python.org/library/os.path.html) and [os](http://docs.python.org/library/os.html) and I had a wealth of information to help me perform my task. I love the internet.

How did I check for passes and fails within the script? The webvtt module returned an exit code of 0 if there were no errors found, and 1 if there was an error; pretty standard fare for UNIX-like programs. Here is the line of Python I use to run the script with a file in the array, and get the results:

{% highlight python %}
retcode = subprocess.call(["webvtt", file_path], stdout=subprocess.PIPE)
{% endhighlight %}

The subprocess module had a method, call, which allows me to call a command line program with an argument. In this case, the argument is the test cases' file name. The third argument in call directs webvtt's output into a black hole at the moment. We only care about the results reported by the test application, not by the parser (for now).

After initially showing the script to David, he suggested that the script should check that the webvtt module was installed before even attempting anything else. After a few minutes of searching, I found that this line would do the trick:

{% highlight python %}
status, results = commands.getstatusoutput("webvtt")
{% endhighlight %}

I only really care about the value of status for now. If you are interested in what the method does, check out the [documentation](http://docs.python.org/library/commands.html). Finding what the correct value of status should be for a program that does not exist was easy; I just played with the method in Python's REPL. Also, this [random blog post](http://shortrecipes.blogspot.ca/2008/11/python-ossystem-return-32512.html) seems to confirm it as well. Thanks W!

After that, I thought it was pretty much ready. If you're interested in seeing [my copy](https://github.com/obsoke/node-webvtt/blob/master/tests/test.py) of the script, or David's [much superior version](https://github.com/humphd/webvtt/blob/seneca/test/spec/run-tests-js.py), check them out!

### The Task at Hand
I currently have two tasks. Firstly, the test.py script needs to be patched. Currently, it just grabs all the files in the good and bad directories. A one line conditional checking that the file's extension is .vtt before adding it to the file list is all that will be needed, I thinks.

The second task is to start writing test cases for the parser. Vince, Thevakaran and I have been tasked with writing tests involving the cue times. I should get on that now, actually...
