# Introduction #

PixelToastereD is a set of bindings for D 2.0 for wonderfulonium
pixeltoaster framebuffer graphics library, which is written in C++.
(You probably know this if you're here)

At the moment, PixelToastereD has been checked only on
Linux platform (I don't have DirectX SDK under windows yet)
and using g++ 4.3.

# Getting started #

Here's a short list of steps that will get you started:

  * obvious thing, you need dmd 2.x, http://www.digitalmars.com/d/download.html
  * grab a copy of pixeltoaster, http://code.google.com/p/pixeltoaster
  * use Mercurial to grab a copy of PixelToastereD
  * apply patch in pixeltoasterInD.patch on pixeltoaster's C++ code
  * currently there are two simple shell scripts, compileExamples`*`, edit any for your needs and run

Bunch of execs should appear in examples subdir, you probably won't to see them right now :]


Please be aware that this code is immature yet.

# Documentation #

PixelToastereD contains no documentation, but it should be pretty strightforward
to get started after looking at the examples.

# Differences #

The main difference between pixeltoaster and PixelToastereD is Listener handling.
You have two options:
  * either you inherit after basic implementation named 'Listener', but that forces you two add extern(C++) for your methods (that's why I don't like it :P) (examples/KeyboardAndMouse.d)
  * or you also inherit after 'Listener', but you compile both PixelToastereD and your code with **version=UseDListener**, in this case simple wrapper between your code and pixeltoaster is created, but you don't have to garbage your code with that ugly extern(C++) stuff :> **(examples/KeyboardAndMouseD.d)**