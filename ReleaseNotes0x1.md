# Introduction #

PixelToastereD is a set of bindings for D 2.0 for wonderfulonium pixeltoaster framebuffer graphics library, which is written in C++. (You probably know this if you're here).

PixelToastered has been tested under linux using g++ and under windows using msvc.

**FYI:** Under windows PixelToastereD loads pixeltoaster.dll dynamically.
That's mainly because:
  1. I don't have coff2omf tool...
  1. so I have no idea how too force DMC (Digital Mars C/C++ compiler) to use DirectX .lib files

# Getting started #

In both cases you need to do following (commands below):
  * download dmd 2.x, http://www.digitalmars.com/d/download.html
  * use mercurial to get PixelToastereD source code
  * grab a copy of pixeltoaster, and copy it to PixelToastereD dir
```
hg clone https://pixeltoastered.googlecode.com/hg/ PixelToastereD
cd PixelToastereD
svn checkout http://pixeltoaster.googlecode.com/svn/trunk/ pixeltoaster-read-only
```

## Linux ##
  * **you need g++ and X11 headers**
  * first you need to apply patch for pixeltoaster:
```
  patch -p0 < pixeltoasterInD.patch
```
  * alter either `compileExamples.sh` or `compileExamples2.sh`, (e.g. change path to dmd2), and run it
  * there should be bunch of binaries in `examples` subdir

## Windows ##

### Easy way ###
  * Download pixeltoaster.dll from Downloads ~~(It's not yet there, but I'll upload it as soon as possible)~~
  * compile script requires **dmc**, http://www.digitalmars.com/download/dmcpp.html
  * edit `compileExamples.bat` for your need (e.g. change path to dmd2), and run it
  * bunch of executables should appear in `examples` subdir

### Hardcore way ###
  * you need **Visual Studio**, I've used MSVC 2005, but any other should do the trick, I was using MSVC from MSDNAA, ~~and I could upload compiled .dll, but I have no idea if that wouldn't break the law, I'll check it later~~
  * you need **dmc**, http://www.digitalmars.com/download/dmcpp.html
  * you need **directx SDK** (pixeltoaster under windows uses DirectX), I'm currently using [Februrary 2010 version](http://google.com/search?q=download+details+Feb+2010+DirectX+SDK) (550M damn you MS)

If you finally got it all, you need to compile pixeltoaster dll. Here are important things:
  * First you should apply the patch for `pixeltoasterInD.patch` file, but since often windows users doesn't have I've just added `PixelToasterModified.h.gz` file to the repo. You should unpack it, rename to `PixelToaster.h` and overwrite the one in `pixeltoaster-read-only` subdir.
  * Open solution: it's in `pixeltoaster-read-only/projects/PixelToaster.sln`
  * **Remember to do the following in both Debug and Release Configuration.**
  * Go to PixelToaster Properties, go to Configuration Properties, C/C++, Preprocessor: In Preprocessor Definitions append **PIXELTOASTER\_TINY**
  * Go to C/C++, General, and in Additional Include Directories, add a path to DirectX, for me it's:
> > ` C:\Program Files\Microsoft DirectX SDK (February 2010)\Include `
  * Go to Linker, General and in Additional Library Directories add a path to your DirectX libs, for me it's:
> > ` C:\Program Files\Microsoft DirectX SDK (February 2010)\Lib\x86 `
  * Apply changes, select Release build and compile PixelToaster, this should create **pixeltoaster.dll** in pixeltoaster-read-only/build

Ok If you've done that part the rest is piece of cake :)
  * edit `compileExamples.bat` for your need (e.g. change path to dmd2), and run it
  * bunch of executables should appear in `examples` subdir

# Documentation #

PixelToastereD contains no documentation, but it should be pretty strightforward to get started after looking at the examples.

# Differences #
The main difference between pixeltoaster and PixelToastereD is /Listener/ handling. You have two options:
  * either you inherit after basic implementation named /Listener/, but that forces you two add extern(C++) for your methods (that's why I don't like it :P) (`examples/KeyboardAndMouse.d`).
  * or you also inherit after /Listener/, but you compile both PixelToastereD and your code with **version=UseDListener**, in this case simple wrapper between your code and pixeltoaster is created, but you don't have to garbage your code with that ugly extern(C++) stuff :> (`examples/KeyboardAndMouseD.d`)

# Tech stuff #

If you're looking for some tech-stuff and rationale, there will be soon wiki page available under [TechNotes0x1](TechNotes0x1.md)