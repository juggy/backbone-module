
#
# Backbone.module memoize the module to be loaded so the order you
# load those module is not important(as long as you do not execute). 
# To define a dependency (on another module property), you can use the 
# module's define function.
#
Backbone.module = (() ->
  # Internal module cache.
  modules = {};

  # Create a new module reference scaffold or load an existing module.
  (name)->
    if modules[name]
      modules[name] 
    else 
      #define is used to define properties within a module
      # properties can have dependencies. Define resolves them.
      define = (options, callback)->

        fire = ()->
          # fire the callback
          if options.bare
            callback(Backbone.module(name))
          else
            Backbone.module(name)[options.property] = callback(Backbone.module(name))
          # fire the event
          Backbone.module(name).trigger "dep:#{options.property}", options.property
        
        if options.depends
          # closure to deal with dependencies
          ((dependencies)->
            for mod, props of dependencies
              # properties must always be an array
              # convert it if otherwise
              dependencies[mod] = props = [props] unless _.isArray(props)

              # called when a dependency is satisfied
              satisfy = (property)->
                dependencies[mod] = _.without dependencies[mod], property

                # when there are no other dependencies, fire away
                if dependencies[mod].length is 0
                  delete dependencies[mod]
                
                fire() if _.keys(dependencies).length is 0
                
              for prop in props
                unless _.isUndefined Backbone.module(mod)[prop]
                  # it is defined!
                  satisfy(prop)
                else
                  # listen for any loading of the different dependencies
                  Backbone.module(mod).bind "dep:#{prop}", satisfy
            )(options.depends)
        else
          fire()

      modules[name] = {module: Backbone.module, define: define}
      _.extend(modules[name], Backbone.Events)
      modules[name]
)()