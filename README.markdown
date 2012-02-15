Scenario editor is (one day) software for editing road networks and scenarios
for traffic simulation.

It depends on CoffeeScript, and ruby/rake for generating new prototypes.

Currently, it is in the prototyping stage. An empty prototype, which loads
dependent libraries, can be found in prototypes/empty. Before it will work,
you must run `make` in the base directory of the prototype to compile the
CoffeeScript. `make watch` will watch the directory for changes and recompile
the JavaScript whenever the CoffeeScript file changes are altered.

To generate a new prototype, run `rake prototype:new[name]`. Prototypes are
dependent on the files in the prototypes/shared directory. Right now, this
simply copies files from prototypes/empty, but it is not guaranteed to remain
as straightforward in the future.
