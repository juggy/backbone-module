Backbone.module = (function() {
  var modules;
  modules = {};
  return function(name) {
    var define;
    if (modules[name]) {
      return modules[name];
    } else {
      define = function(options, callback) {
        var fire;
        fire = function() {
          if (options.bare) {
            callback(Backbone.module(name));
          } else {
            Backbone.module(name)[options.property] = callback(Backbone.module(name));
          }
          return Backbone.module(name).trigger("dep:" + options.property, options.property);
        };
        if (options.depends) {
          return (function(dependencies) {
            var mod, prop, props, satisfy, _results;
            _results = [];
            for (mod in dependencies) {
              props = dependencies[mod];
              if (!_.isArray(props)) {
                dependencies[mod] = props = [props];
              }
              satisfy = function(property) {
                dependencies[mod] = _.without(dependencies[mod], property);
                if (dependencies[mod].length === 0) {
                  delete dependencies[mod];
                }
                if (_.keys(dependencies).length === 0) {
                  return fire();
                }
              };
              _results.push((function() {
                var _i, _len, _results2;
                _results2 = [];
                for (_i = 0, _len = props.length; _i < _len; _i++) {
                  prop = props[_i];
                  _results2.push(!_.isUndefined(Backbone.module(mod)[prop]) ? satisfy(prop) : Backbone.module(mod).bind("dep:" + prop, satisfy));
                }
                return _results2;
              })());
            }
            return _results;
          })(options.depends);
        } else {
          return fire();
        }
      };
      modules[name] = {
        module: Backbone.module,
        define: define
      };
      _.extend(modules[name], Backbone.Events);
      return modules[name];
    }
  };
})();