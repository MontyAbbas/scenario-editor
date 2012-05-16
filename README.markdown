Scenario editor is (one day) software for editing road networks and scenarios
for traffic simulation.

Git, Node.js and npm install:
=======================
Before getting started you'll need to install git, node.js and npm(npm comes with node.js).
Here are instructions for installing node.js as well as reference to installing git:
http://howtonode.org/how-to-install-nodejs 


app directory
=============
The app directory contains everything necessary to run the scenario-editor. In order to run the
application do the following:
1) At command line, navigate to the app directory.
2) In the app directory, run "make" at the command-line.
3) "make" will compile the following to javascript: *
     - all files in the app/coffeescripts folder
     - all files in the libs/aurora-coffee folder ** - 
4) Open app/main.html in your browser and load an appropriate xml file to see it displayed on the map.
5) Debugging and generally viewing the what is in the browser memory can be done in Chrome *** by:
   a) View -> Developer -> Javascript console. The console will open and display any javascript errors/messages the browser encounters.
   b) More on debugging in Chrome can be found here: http://jtaby.com/2012/04/23/modern-web-development-part-1.html

* - Why does it make "hang"? After executing "make" the program will appear to "hang" in the terminal window. 
    This is by design, it is watching for any changes to app/coffeescripts folder. 
    If there is change it will be automatically compiled to javascript. The watching can be stopped by removing
    the --watch flag from the final line in the app/Makefile file.

** - currently the scenario-editor is displaying information in line with aurora schema definition. This will change 
     to the sirius schema definition in the near future. In order to
     compile the correct coffeescripts(aurora or sirius or whatever in the future) you need to:
     1) open app/Makefile in your text editor and change the path from libs/aurora-coffee to libs/sirius-coffee

*** - Debugging can be done in firefox as well. I would recommend installing the Firebug plugin. A similar process for opening the javascript 
      console is available.


prototypes directory
===================
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
