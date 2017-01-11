---
title: A Boilerplate for WebGL Projects
layout: post
date: 2015-12-10 12:00
tags: [webgl, webdev, webpack]
header: 2015-12-10-header.png
headertext: A beautiful WebGL triangle.
---
* *2015/12/12: Added source map support*

Between [Grunt](http://gruntjs.com/), [Gulp](http://gulpjs.com/),
[Webpack](https://webpack.github.io/) and [Broccoli](http://broccolijs.com/), it seems like a new
build tool/asset pipeline/module bundler/etc arrives in the land of JavaScript every few months.
While learning WebGL, I started to look into ways to make starting a new project and development a
bit easier. I've been using Webpack for work-related purposes over the past few months and I've
really grown to like its easy-to-read config files, async code splitting abilities and wide plugin
ecosystem. "Since it helped make my React-based development smooth as butter," I thought to myself,
"perhaps using Webpack would help to make WebGL development go just as smoothly."

This post follows the steps and rationale used to build a Webpack-based boilerplate for WebGL. If
you just want to look at the code, you can
[grab the source here](https://github.com/obsoke/webgl-webpack-boilerplate).

### Getting Started

For this build system, all you need to start with is Node.js + npm. We will use Webpack as our
module loader/build tool combo. Another invaluable tool in our arsenal will be
[Babel](http://babeljs.io/) library for allowing use of ES6+ features. This guide assumes you have
basic familiarity with JavaScript and using npm to install modules.

We will start off by installing Webpack globally. I like doing this so I can just use `webpack` on
the command line from anywhere:

{% highlight console %}
$ npm install -g webpack
{% endhighlight %}

Webpack is a tool used to bundle files into modules. It has a vast variety of plugins created by
both the Webpack team and community to allow modules to be created using both JavaScript and
non-JavaScript files. You can even use it in conjunction with tools like Grunt or Gulp! We will be
making use of Webpack to transpile our ES6 code to something modern browsers can read with Babel, a
plugin that allow us to write our GLSL shader code like you would for a desktop application, and
finally bundle all our code into a single (or multiple) JavaScript files.

Let's create a new directory called `webgl_project`:

{% highlight console %}
$ mkdir webgl_project
$ cd webgl_project
{% endhighlight %}

We will be saving a list of libraries and tools we need to `package.json` so let's create one first:

{% highlight console %}
$ npm init -y
{% endhighlight %}

Using the `-y` flag uses default values; we will edit these shortly. Personally, I'd rather edit
these fields in a text editor rather than input them into a prompt.

Next, we will install our dependencies required for development, including:

* `webpack`: The webpack documentation recommends saving webpack as a local dev. dependency
* `webpack-dev-server`: Used to watch files & recompile on changes, servers files
* `babel-core`: Compiler used to make our ES6 code usable in modern browsers
* `babel-preset-es2015`: Since version 6, Babel comes with no settings out of the box. This is a preset to compile ES6.
* `babel-loader`: Webpack plugin to transpile JavaScript files before creating modules out of them
* `html-webpack-plugin`: A plugin used to auto-generate a HTML file with all webpack modules included.
* `webpack-glsl-loader`: Webpack plugins to load our shaders from files into strings

Let's install these modules all at once:

{% highlight console %}
$ npm install webpack webpack-dev-server babel-core babel-reset-es2015 babel-loader html-webpack-plugin webpack-glsl-loader --save-dev
{% endhighlight %}

At this point, I usually like to open `package.json` and start making some edits. This is what I end up with:

{% highlight json %}
{
  "name": "webgl-webpack-boilerplate",
  "version": "1.0.0",
  "private": true,
  "description": "a boilerplate webpack project for getting started with WebGL.",
  "scripts": {},
  "author": "Dale Karp <dale@dale.io> (http://dale.io)",
  "license": "CC-BY-4.0",
  "repository": {
    "type": "git",
    "url": "https://github.com/obsoke/webgl-webpack-boilerplate"
  },
  "devDependencies": {
    "babel-core": "^6.1.19",
    "babel-loader": "^6.1.0",
    "babel-preset-es2015": "^6.1.18",
    "html-webpack-plugin": "^1.7.0",
    "webpack": "^1.12.4",
    "webpack-dev-server": "^1.12.1",
    "webpack-glsl-loader": "^1.0.1"
  }
}
{% endhighlight %}

We'll come back to this file to add some commands to use to the `scripts` key. For now, let's hop
back to the terminal.

### Project Structure

I wanted the file structure for an intial project to be simple:

{% highlight console %}
.
├── package.json # lists dependencies for easy re-install
├── src
│   ├── index.html # html to use as template for generated output html
│   ├── js
│   │   └── main.js # entry point for our application
│   └── shaders
│       └── ... # glsl files go here
└── node_modules/ # folder containing our dependencies
{% endhighlight %}

This structure can be created with `mkdir` & `touch` commands.

Now that we have a clear idea of what files are going to be a part of the project, let's get a Git repository
going and set up a `.gitignore` file:

{% highlight console %}
$ git init
$ touch .gitignore
{% endhighlight %}

Open up `.gitignore` up and enter the following:

{% highlight console %}
node_modules
dist
{% endhighlight %}

Since the contents of these two folders are generated, we shouldn't commit them to version control.

With that out the way, let us continue by setting up Webpack.

### Webpack Configuration

Webpack can be configured a few different ways: with its own configuration files, via the command line with flags,
or as a module in Gulp/Grunt. We'll be using the config file route. Create a file in the root of your project
directory called `webpack.config.js`. Input the following:

{% highlight js %}
var path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var ROOT_PATH = path.resolve(__dirname);
var ENTRY_PATH = path.resolve(ROOT_PATH, 'src/js/main.js');
var SRC_PATH = path.resolve(ROOT_PATH, 'src');
var JS_PATH = path.resolve(ROOT_PATH, 'src/js');
var TEMPLATE_PATH = path.resolve(ROOT_PATH, 'src/index.html');
var SHADER_PATH = path.resolve(ROOT_PATH, 'src/shaders');
var BUILD_PATH = path.resolve(ROOT_PATH, 'dist');

var debug = process.env.NODE_ENV !== 'production';

module.exports = {
    entry: ENTRY_PATH,
    plugins: [
        new HtmlWebpackPlugin({
            title: 'WebGL Project Boilerplate',
            template: TEMPLATE_PATH,
            inject: 'body'
        })
    ],
    output: {
        path: BUILD_PATH,
        filename: 'bundle.js'
    },
    resolve: {
        root: [JS_PATH, SRC_PATH]
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                include: JS_PATH,
                exclude: /(node_modules|bower_components)/,
                loader: 'babel',
                query: {
                    cacheDirectory: true,
                    presets: ['es2015']
                }
            },
            {
                test: /\.glsl$/,
                include: SHADER_PATH,
                loader: 'webpack-glsl'
            }
        ]
    },
    debug: debug,
    devtool: debug ? 'eval-source-map' : 'source-map'
};
{% endhighlight %}

Let's take a look at what's going on here:

#### File header
Firstly, we import some modules such as `path` and our `html-webpack-plugin`. We also define some
constants containing the absolute paths to the folders we wil keep various types of files in, along
with the entry and output paths.

We also check for the presence of the environmental variable `NODE_ENV` to determine whether to
build production or development bundles.

#### `entry`
The JavaScript entry point of our application.

#### `plugins`
The `html-webpack-plugin` generates HTML files that already have appropriate `script` and `link`
tags to bundled JS and CSS bundles. We'll make use of that plugin with a few options. `title` is the
value of the `title` tag. `template` is a path to the HTML file we want to base our index.html off
of. Finally, `inject` allows us to control where our `script` tags are being created. Valid values
are `body` and `head`. We will set up our HTML template after configuring Webpack.

#### `output`
Here we define where we want Webpack to place the modules it creates.

#### `resolve`
`resolve`'s `root` key lets you tell Webpack which folders to search in when importing one file into another.
For example, imagine the following file structure:

{% highlight console %}
.
├── js
│   ├── Component
│   │   └── Dude.js
│   ├── main.js
│   └── Utility
│       └── VectorUtils.js
└── shaders
{% endhighlight %}

The contents of `js/utility/VectorUtils.js` look something like this:

{% highlight js %}
export function getDotProduct(v1, v2) {
    // gets & returns dot product
}
{% endhighlight %}

Without setting the `resolve.root` property in our Webpack settings, the way to include `VectorUtils.js` in `Dude.js` would look something like this:

{% highlight js %}
import { getDotProduct } from '../VectorUtils.js';

export default class Dude extends Person {
    // use getDotProduct somewhere in here
}
{% endhighlight %}

After setting `resolve.root` to include our `src/js` path, we can treat that as a root directory that Webpack will search through to find other modules. This lets us write import paths like this:

{% highlight js %}
import { getDotProduct } from 'Utility/VectorUtils.js';

export default class Dude extends Person {
    // use getDotProduct somewhere in here
}
{% endhighlight %}

Since we've also added `src` as a root path, we'll be able to include shaders just by writing something like this:

{% highlight js %}
import boxShader from 'Shaders/boxShader_v.glsl';
{% endhighlight %}

This makes importing files easy, no matter what directory you happen to be working in.

#### `module`
The `loader` key on `module` tells Webpack which files to load into modules, and how to load them.
We've defined two loaders: one for JavaScript files, and one for our GLSL shaders. `test` is a
regular expression that will bundle the files that match it; obviously for a JavaScript loader, we
want Webpack to find modules ending with `.js`. We don't want Webpack to do anything with our
dependencies unless we explicitly import one, so we tell Webpack to `exclude` them. The `loader` key
is the name of the Webpack plugin used to process JS files. Since we want to be able to write using
ES6 syntax, Babel will handle that responsibility. Because Babel 6 comes with no options out of the
box, we need to tell it to use the `es2015` presets package we installed earlier. Enabling directory
caching will give us faster compile times so of course we enable that.

Our last loader is for our shader files, ending with `.glsl`. Here, we simply tell Webpack to use
the `webpack-glsl` loader.

#### `debug`
Some loaders will perform optimizations when building bundles depending on whether the `debug` key
is set to true or false.

#### `devtool`
At the moment, this tells Webpack which style of source maps to use. `source-map` is recommended for
production use only, so we'll use `eval-source-map` which is faster and produces cache-able source
maps.

With that, our configuration of Webpack is complete. Not too bad, eh?

Let's re-open `package.json` and add some commands to `scripts` that will make interacting with
webpack a bit easier:

{% highlight js %}
{
    // ...
    "scripts": {
        "build": "NODE_ENV=production webpack --progress --colors",
        "watch": "webpack --progress --colors --watch",
        "dev-server": "webpack-dev-server --progress --colors --inline --hot"
    },
    // ...
}
{% endhighlight %}

Webpack will check for `webpack.config.js` and use it if found. I'm using flags to show build
progress and to give the output a bit more colour. Any key added to the `scripts` object can be used
by running `npm run <keyname>`. This gives us three easily accessible commands:

* `NODE_ENV=production npm run build`: Builds our project into `/dist/`. Uses a flag to tell Webpack we want loaders to build production-mode modules.
* `npm run watch`: Builds our project and watches files for changes, re-builds on change.
* `npm run dev-server`: Builds our project and watches files for changes, also serves files from a web server. The `--inline --hot` flags enable Hot Module replacement, which will update your page without any user input. You can read more about HMR in [webpack-dev-server's documentation](http://webpack.github.io/docs/webpack-dev-server.html).

Now we have one thing left to do, and that is to create our `index.html` in `/dist`. This is what the contents
look like:

{% highlight html %}
<!doctype html>
<html lang="en">
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
        <title>{% raw %}{%= o.htmlWebpackPlugin.options.title %}{% endraw %}</title>
    </head>
    <body>
        <canvas id="canvas"></canvas>
    </body>
</html>
{% endhighlight %}

That weird value used in the `title` tag allows Webpack to change the page's title depending on the
value of the `title` key passed to `html-webpack-plugin`. As you can see, no `script` tags are
needed - Webpack will handle that for us.

And with that, the boilerplate is complete. "But Dale," you exclaim, "I don't see the point of this.
You made a simple Webpack config, so what?"

### Motivations

My main motivations behind this came from my own experiences trying to learn WebGL. I've noticed
that many WebGL tutorials will demonstrate shader usage in WebGL in one of two ways:

1. Write a JavaScript string containing the shader code.
2. Have a `script` element of type `x-ver-shader` and grab the element's content from JavaScript.

Personally, I don't like either of these solutions. The first one is just ugly, unreadable and
difficult to maintain yet most of the WebGL resources I see introduce shaders using this
method. The second is slightly better, but I prefer to keep shaders in their own files, where I can
use an editor with syntax highlighting to make readability a bit easier.

I completely understand why tutorial writers do this. WebGL is complex, and wrapping your head
around everything needed to render a simple triangle in shader-based GL can be a lot to take in at
once. Once you get your head around those concepts, though, then what? What's the best way to deal
with shaders moving forward as a project scales? I'm not claiming this boilerplate is anywhere close
to the best, but for me it works. Hopefully it does for you too (and if it doesn't, please open an
issue/PR on the [GitHub repo](https://github.com/obsoke/webpack-webgl-boilerplate) and let me know).

### Mini-example: Hello Triangle

Let's go through a short example of how one would potentially use this boilerplate to easily load
GLSL shaders. Imagine we have two shaders in our `src/shaders` directory, called `box_vert.glsl` and
`box_frag.glsl` containing our vertex and fragment shader, respectively. No need for `<script>`
tags or multi-line strings! Just import it when you need it, where you need it.

{% highlight js %}
// import our shaders and store them variables
import boxVertShaderSource from 'shaders/box_vert.glsl';
import boxFragShaderSource from 'shaders/box_frag.glsl';

const canvas = document.getElementById('canvas');
const gl = canvas.getContext('experimental-webgl');

// ...

// time to create our shader program with a handy function!
// it expects the gl context and strings containing shaders.
let program = createProgramFromGLSL(gl, boxVertShaderSource, boxFragShaderSource);
{% endhighlight %}

### That's all!

I hope you found this useful in some way. If you have any suggestions on how to improve the
boilerplate, please open an issue on the
[GitHub repo](https://github.com/obsoke/webpack-webgl-boilerplate).
