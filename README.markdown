# Module - what is it good for?

Backbone Module is a simple and elegant solution to load your in browser javascript dependencies. It leverages Backbone eventing and Underscore to bring even more goodness.

First of all, it is not a script loader like require.js or a bunch of other libraries. I believe you are better off loading a single monolitic file in the browser and have it cached instead of loading them all by yourself (and doing the browser's job of optimizing the load).

You might say: "Excuse me mister, but, if I may object, a dependency loader is useless in a monolitic file" and to that I will answer "You are right, if you want to bang your head against the wall everytime you want to refactor something".

The truth is that you do not develop a web app in a single javascript file. You create multiple files (each with it's own scope), you assemble them and upload them to a CDN somewhere in the sky next to the moon. I use Jammit to do so in development.

When you do that and do not think about anything, you will end up with loading exceptions in the browser. Oh! that file should load before this one, let's change the config. Oh! now it is this one. Back and forth and back and forth. No rapid development.

The solution I use is simple. You wrap each file in a Backbone.module call and reference them using that same Backbone.module call.

    ((mod)->
      #... my app code here
      mod.start = ->
        console.log "starting"
    (Backbone.module("app")))

    Backbone.module("app").start()

This is fine when you do not have any dependencies between your modules. When you have dependencies, you should use the define call:

    Backbone.module("core/models").define 
      property: "Quote"
      depends: {"core/models" : "EventedModel"}
    , (mod)->
      mod.Quote = mod.EventedModel.extend
        initialize: ->
         #...

So that reads: for the "core/models" modules define a property called "Quote" that will depend on the property "EventedModel" of the "core/model" module. You can also define multiple depedencies from multiple modules. That is pretty all there is to it.

My Backbone applications are usually built like that:

* core
  * index.coffee (the main "core" module which references all sub module like "models")
  * helpers
  * models
  * routers
  * views
  * templates
* project
  * index.coffee
  * routers
  * models
  * ...
* quote
  * index.coffee
  * routers
  * models
  * ...
* invoice
  * index.coffee
  * routers
  * models
  * ...

My index.coffee looks like this

    ((core)->
      
      _.extend core,
        views : core.module("core/views")
        models : core.module("core/models")
        helpers: core.module("core/helpers")
        routers: core.module("core/routers")

    )(Backbone.module("core"))

Enjoy!



# License (MIT)

Copyright (c) 2011 Julien Guimont <julien.guimont@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.