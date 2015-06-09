# Introduction #

Here are some random notes and thoughs mainly for D developers,
about different problems I had and how I bypassed them.

# PixelToasterWrapper #

First of all, all the stuff in pixeltoaster is placed
in _PixelToaster_ namespace. D doesn't like C++ namespaces,
that's the reason, I've created PixelToasterWrapper.

It's a minimalistic piece of code in cpp, that provides
simple layer between D's PixelToastereD and C++'es pixeltoaster.

Under Linux it's simply wrapper for functions from pixeltoaster namespace.

Under Windows it dynamically loads `pixeltoaster.dll` library via _LoadLibrary_,
parses headers and tries to find functions that matches _createDisplay_
and _createTimer_.

There are some _IDisplay_ and _ITimer_ dummies, iirc this is for dmc, so it can generate proper symbols (I'm not sure right now, but I think if I tried to use _PixelToaster::DisplayInterface`*`_, the generated symbols weren't right, and later dmd couldn't find them).

http://code.google.com/p/pixeltoastered/source/browse/PixelToasterWrapper.cpp

# PixelToastered #

## Structs ##
I've simply rewritten _TrueColorPixel_ and _FloatingColorPixel_ structs to D,
this was quite obvious since otherwise it'd be quite inconvenient to use
make any use of pixeltoaster :>

I've also rewritten _Mouse_ struct.

## Display ##
_PixelToastereD.Display_ is simply a copy of a _PixelToaster::Display_ class.

There are some differences (like throwing exceptions, wrapper is missing ATM).

There are some differences in _mode()_, _output()_ and _listener(...)_, but I'll describe them further.

## IDisplay ##
I think this is the most important thing in PixelToastered.

### interface ###
There are almost two different interfaces (one for MSVC, and one that we can call **normal** :>)

**normal** IDisplay is basically a copy of a _PixelToaster::DisplayInterface_ abstract-base-class, and everything seems to be working fine.

MSVC however does some crazy things. If there are overloads for the method with given name, it seems that it place the ptrs in vtbl "near-each-other".

That wouldn't be a big problem we could simply change order in header file, and
everything should be fine...

..but things get strange now, it seems that if you place overloaded name (in header file)
one-next to each other like:
```
...
virtual void listener( class Listener * listener ) = 0;
virtual class Listener* listener() const = 0;
...
```

MSVC (at least 2005 on which I've done the tests) places pointers in vtbl **ALWAYS** in reverse order.

(We can argue if getters/setters should be named like that, but that's not the point here :P)

That's why there's one big _version_ block in _IDisplay_

### mode and output ###
There is one more difference in case of _mode()_ and _output()_.

They both return object using _"return-by-value"_ semantic.

First take a look at following link:
http://www.parashift.com/c++-faq-lite/ctors.html#faq-10.9

MSVC seems to be using figuring-out the case and does exactly what is describes in link above. (In fact that means it calls assignment operator).

Because of that, code like (C++):
```
Mode m = display->mode();
```
is tranlated to something like (pseudo-code):
```
Mode m;
display->copyInternalMode(&m);
```

and that's exactly why _IDisplay.mode()_ and _IDisplay.output()_,
have the following signature in case of MSVC:
```
void mode(ref ModeCPP data) const;
void output(ref OutputCPP data) const;
```

(If you ask - why, well, otherwise stack get smashed :>)

## UseDListerner ##

_version(UseDListener)_ is nothing really fancy, but I didn't like
_extern(C++)_ in my D code ;P

When listener is registrated there is created simple dummy, that inherits after
C++ interface and passes all the callbacks to the upper D-listener.