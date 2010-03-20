module PixelToastereD;

/+
This file is part of PixelToastereD.

PixelToastereD is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PixelToastereD is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PixelToastereD.  If not, see <http://www.gnu.org/licenses/>.
+/


enum Output { Default, Windowed, Fullscreen }
enum Mode { TrueColor, FloatingPoint, BadMode }

struct ModeCPP {
	Mode val;
}

struct OutputCPP {
	Output val;
}

struct FloatingPointPixel {
    float r, g, b, a;
}

union TrueColorPixel {
    uint integer;
    struct {
        version (LittleEndian) {
            ubyte b, g, r, a;
        } else {
            ubyte a, r, g, b;
        }
    }
}

struct Rectangle {
    int xBegin;
    int xEnd;
    int yBegin;
    int yEnd;
}


class Display {
    IDisplay d_internal;
    IDisplay d_cppDummy;
    Listener d_listener;
    version (UseDListener){
        ICppListener d_cppWrapper;
    }
    public:
    this() {
        d_internal = PixelToasterWrapper_createDisplay();
        if (d_internal is null) {
            throw new Exception("cannor create display object, is pixeltoaster.dll present?");
        }
        //d_cppDummy = new CppDummyDisplay(this);
        //d_internal.wrapper(d_cppDummy);
    }

    this(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint) {
        d_internal  = PixelToasterWrapper_createDisplay();
        if (d_internal is null) {
            throw new Exception("cannor create display object, is pixeltoaster.dll present?");
        }
        //d_internal.wrapper( this );
        open(title, width, height, output, mode);
    }

    ~this() {
        if (d_internal) {
            PixelToasterWrapper_destroyDisplay(cast(void*)d_internal);
            d_internal = null;
        }
    }

    bool open(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint ) {
        if (d_internal) {

            return d_internal.open(title, width, height, OutputCPP(output), ModeCPP(mode));
        }
        return false;
    }

    void close() {
        if (d_internal) {
            d_internal.close();
        }
    }

    bool open() {
        if (d_internal) {
            return d_internal.open();
        }
        return false;
    }

    bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null) {
        if (d_internal) {
            return d_internal.update(pixels, dirtyBox);
        }
        return false;
    }

    bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null) {
        if (d_internal) {
            return d_internal.update( pixels, dirtyBox );
        }
        return false;
    }

    const char* title() const {
        if (d_internal) {
            return d_internal.title();
        }
        return "\0".dup.ptr;
    }

    void title(char* title) {
        if (d_internal) {
            d_internal.title(title);
        }
    }

    int width() {
        if (d_internal) {
            return d_internal.width();
        }
        return 0;
    }

    int height() {
        if (d_internal) {
            return d_internal.height();
        }
        return 0;
    }

    Mode mode() {
        if (d_internal) {
            version (MSVC) {
                ModeCPP m;
                d_internal.mode(m);

            } else {
                ModeCPP m = d_internal.mode();
            }
            return m.val;
        }
        return Mode.FloatingPoint;
    }

    Output output() {
        if (d_internal) {
            version (MSVC) {
                OutputCPP o;
                d_internal.output(o);

            } else {
                OutputCPP o = d_internal.output();
            }
            return o.val;
        }
        return Output.Default;
    }

    void listener(Listener listener) {
        if (d_internal) {
            version (UseDListener) {
                d_internal.listener(null);
                if (d_cppWrapper !is null) { delete d_cppWrapper; }

                d_cppWrapper = new CppListener(listener);
                d_internal.listener(d_cppWrapper);
                d_listener = listener;

            } else {
                d_internal.listener(listener);
                d_listener = listener;
            }
        }
    }

    const(Listener) listener() const { 
        return d_listener;
    }

    void wrapper(IDisplay wrapper ) { }

    IDisplay wrapper() {
        return null;
    }
}

class Timer { // {{{
    ITimer d_internal;
    public:

    this() {
        d_internal = PixelToasterWrapper_createTimer();
    }

    ~this() {
        if (d_internal) {
            PixelToasterWrapper_destroyTimer(cast(void*)d_internal);
            d_internal = null;
        }
    }

    void reset() {
        if (d_internal) {
            d_internal.reset;
        }
    }

    double time() {
        if (d_internal) {
            return d_internal.time;
        }
        return 0.0;
    }

    double delta() {
        if (d_internal) {
            return d_internal.delta;
        }
        return 0.0;
    }

    double resolution() {
        if (d_internal) {
            return d_internal.resolution;
        }
        return 0.0;
    }

    void wait(double seconds) {
        if (d_internal) {
            d_internal.wait(seconds);
        }
    }
} // }}}

version (UseDListener) {
    class Listener {
        bool defaultKeyHandlers() const { return true; }
        void onKeyDown(IDisplay display, Key key) {}
        void onKeyPressed(IDisplay display, Key key) {}
        void onKeyUp(IDisplay display, Key key) {}
        void onMouseButtonDown(IDisplay display, Mouse mouse) {}
        void onMouseButtonUp(IDisplay display, Mouse mouse) {}
        void onMouseMove(IDisplay display, Mouse mouse) {}
        void onActivate(IDisplay display, bool active) {}
        void onOpen(IDisplay display) {}
        bool onClose(IDisplay display) { return true; }
    }

    class CppListener : ICppListener { 
        public:
            override extern(C++) bool defaultKeyHandlers () const                            { return d_l.defaultKeyHandlers; }
            override extern(C++) void onKeyDown          (IDisplay display, Key key)         { d_l.onKeyDown         (display, key); }
            override extern(C++) void onKeyPressed       (IDisplay display, Key key)         { d_l.onKeyPressed      (display, key); }
            override extern(C++) void onKeyUp            (IDisplay display, Key key)         { d_l.onKeyUp           (display, key); }
            override extern(C++) void onMouseButtonDown  (IDisplay display, Mouse mouse)     { d_l.onMouseButtonDown (display, mouse); }
            override extern(C++) void onMouseButtonUp    (IDisplay display, Mouse mouse)     { d_l.onMouseButtonUp   (display, mouse); }
            override extern(C++) void onMouseMove        (IDisplay display, Mouse mouse)     { d_l.onMouseMove       (display, mouse); }
            override extern(C++) void onActivate         (IDisplay display, bool active)     { d_l.onActivate        (display, active); }
            override extern(C++) void onOpen             (IDisplay display)                  { d_l.onOpen            (display); }
            override extern(C++) bool onClose            (IDisplay display)                  { return d_l.onClose    (display); }

            this(Listener l) { d_l = l; }
        private:
            Listener d_l;
    }

} else {

    class Listener : ICppListener { 
        public:
            override extern(C++) bool defaultKeyHandlers () const                            { return true; }
            override extern(C++) void onKeyDown          (IDisplay display, Key key)         { }
            override extern(C++) void onKeyPressed       (IDisplay display, Key key)         { }
            override extern(C++) void onKeyUp            (IDisplay display, Key key)         { }
            override extern(C++) void onMouseButtonDown  (IDisplay display, Mouse mouse)     { }
            override extern(C++) void onMouseButtonUp    (IDisplay display, Mouse mouse)     { }
            override extern(C++) void onMouseMove        (IDisplay display, Mouse mouse)     { }
            override extern(C++) void onActivate         (IDisplay display, bool active)     { }
            override extern(C++) void onOpen             (IDisplay display)                  { }
            override extern(C++) bool onClose            (IDisplay display)                  { return true; }
    }
}

// not needed :P
/+
    class CppDummyDisplay : IDisplay {
        override extern(C++)
        bool open(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint) {
            return false;
        }
        override extern(C++)
        void close() {
        }

        override extern(C++)
        bool open() const {
            return false;
        }

        override extern(C++)
        bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null) {
            return true;
        }

        override extern(C++)
        bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null) {
            return true;
        }

        override extern(C++)
        const char* title() const { return d_d.title(); }
        override extern(C++)
        void title(char* title) { d_d.title(title); }

        override extern(C++)
        int width() const { return 0; }
        override extern(C++)
        int height() const { return 0;}
        override extern(C++)
        Mode mode() const { return Mode.BadMode; }
        override extern(C++)
        Output output() const { return Output.Default; }

        override extern(C++)
        void listener(ICppListener listener ) {}
        override extern(C++)
        ICppListener listener() { return null; }

        override extern(C++)
        void wrapper(IDisplay wrapper) {
            assert(0, "warning calling wrapper in CppDummyDisplay");
        }
        override extern(C++)
        IDisplay wrapper() {
            return this;
        }

        this(Display d) { d_d = d; }
        private:
        Display d_d;
    }+/

enum Key { // {{{
    Enter          = '\n',      ///< enter key
    BackSpace      = '\b',      ///< backspace key
    Tab            = '\t',      ///< tab key
    Cancel         = 0x03,      ///< cancel key
    Clear          = 0x0C,      ///< clear key
    Shift          = 0x10,      ///< shift key
    Control        = 0x11,      ///< control key
    Alt            = 0x12,      ///< alt key
    Pause          = 0x13,      ///< pause key
    CapsLock       = 0x14,      ///< capslock key
    Escape         = 0x1B,      ///< escape key
    Space          = 0x20,      ///< space key
    PageUp         = 0x21,      ///< page up key
    PageDown       = 0x22,      ///< page down key
    End            = 0x23,      ///< end key
    Home           = 0x24,      ///< home key
    Left           = 0x25,      ///< left key
    Up             = 0x26,      ///< up arrow key
    Right          = 0x27,      ///< right arrow key
    Down           = 0x28,      ///< down arrow key
    Comma          = 0x2C,      ///< comma key ','
    Period         = 0x2E,      ///< period key '.'
    Slash          = 0x2F,      ///< slash key '/'
    Zero           = 0x30,      ///< zero key
    One            = 0x31,      ///< one key
    Two            = 0x32,      ///< two key
    Three          = 0x33,      ///< three key
    Four           = 0x34,      ///< four key
    Five           = 0x35,      ///< five key
    Six            = 0x36,      ///< six key
    Seven          = 0x37,      ///< seven key
    Eight          = 0x38,      ///< eight key
    Nine           = 0x39,      ///< nine key
    SemiColon      = 0x3B,      ///< semicolon key ';'
    Equals         = 0x3D,      ///< equals key '='
    A              = 0x41,      ///< a key
    B              = 0x42,      ///< b key
    C              = 0x43,      ///< c key
    D              = 0x44,      ///< d key
    E              = 0x45,      ///< e key
    F              = 0x46,      ///< f key
    G              = 0x47,      ///< g key
    H              = 0x48,      ///< h key
    I              = 0x49,      ///< i key
    J              = 0x4A,      ///< j key
    K              = 0x4B,      ///< k key
    L              = 0x4C,      ///< l key
    M              = 0x4D,      ///< m key
    N              = 0x4E,      ///< n key
    O              = 0x4F,      ///< o key
    P              = 0x50,      ///< p key
    Q              = 0x51,      ///< q key
    R              = 0x52,      ///< r key
    S              = 0x53,      ///< s key
    T              = 0x54,      ///< t key
    U              = 0x55,      ///< u key
    V              = 0x56,      ///< v key
    W              = 0x57,      ///< w key
    X              = 0x58,      ///< x key
    Y              = 0x59,      ///< y key
    Z              = 0x5A,      ///< z key
    OpenBracket    = 0x5B,      ///< open bracket key '['
    BackSlash      = 0x5C,      ///< back slash key '\'
    CloseBracket   = 0x5D,      ///< close bracket key ']'
    NumPad0        = 0x60,      ///< numpad 0 key
    NumPad1        = 0x61,      ///< numpad 1 key
    NumPad2        = 0x62,      ///< numpad 2 key
    NumPad3        = 0x63,      ///< numpad 3 key
    NumPad4        = 0x64,      ///< numpad 4 key
    NumPad5        = 0x65,      ///< numpad 5 key
    NumPad6        = 0x66,      ///< numpad 6 key
    NumPad7        = 0x67,      ///< numpad 7 key
    NumPad8        = 0x68,      ///< numpad 8 key
    NumPad9        = 0x69,      ///< numpad 9 key
    Multiply       = 0x6A,      ///< multiply key '*'
    Add            = 0x6B,      ///< add key '+'
    Separator      = 0x6C,      ///< separator key '-'
    Subtract       = 0x6D,      ///< subtract key '-'
    Decimal        = 0x6E,      ///< decimal key '.'
    Divide         = 0x6F,      ///< divide key '/'
    F1             = 0x70,      ///< F1 key
    F2             = 0x71,      ///< F2 key
    F3             = 0x72,      ///< F3 key
    F4             = 0x73,      ///< F4 key
    F5             = 0x74,      ///< F5 key
    F6             = 0x75,      ///< F6 key
    F7             = 0x76,      ///< F7 key
    F8             = 0x77,      ///< F8 key
    F9             = 0x78,      ///< F9 key
    F10            = 0x79,      ///< F10 key
    F11            = 0x7A,      ///< F11 key
    F12            = 0x7B,      ///< F12 key
    Delete         = 0x7F,      ///< delete key
    NumLock        = 0x90,      ///< numlock key
    ScrollLock     = 0x91,      ///< scroll lock key
    PrintScreen    = 0x9A,      ///< print screen key
    Insert         = 0x9B,      ///< insert key
    Help           = 0x9C,      ///< help key
    Meta           = 0x9D,      ///< meta key
    BackQuote      = 0xC0,      ///< backquote key
    Quote          = 0xDE,      ///< quote key
    Final          = 0x18,      ///< final key
    Convert        = 0x1C,      ///< convert key
    NonConvert     = 0x1D,      ///< non convert key
    Accept         = 0x1E,      ///< accept key
    ModeChange     = 0x1F,      ///< mode change key
    Kana           = 0x15,      ///< kana key
    Kanji          = 0x19,      ///< kanji key
    Undefined      = 0x0        ///< undefined key
} // }}}

extern (C++) {
    struct Mouse
    {
        struct Buttons
        {
            bool left;        ///< true if left button is pressed.
            bool middle;      ///< true if middle button is pressed.
            bool right;       ///< true if right button is pressed.
        }

        Buttons buttons;      ///< mouse button state. indicates which mouse buttons are currently pressed.
        float x;              ///< current mouse cursor x position. standard range is from 0 to display width - 1, from left to right. values outside this range occur when the user drags the mouse outside the display window.
        float y;              ///< current mouse cursor y position. standard range is from 0 to display height - 1, from top to bottom. values outside this range occur when the user drags the mouse outside the display window.
    }


    interface ICppListener { 
        bool defaultKeyHandlers() const;
        void onKeyDown(IDisplay display, Key key);
        void onKeyPressed(IDisplay display, Key key);
        void onKeyUp(IDisplay display, Key key);
        void onMouseButtonDown(IDisplay display, Mouse mouse);
        void onMouseButtonUp(IDisplay display, Mouse mouse);
        void onMouseMove(IDisplay display, Mouse mouse);
        void onActivate(IDisplay display, bool active);
        void onOpen(IDisplay display);
        bool onClose(IDisplay display);
    }

    interface IDisplay {
        version (MSVC) {
            bool open() const;
            bool open(const char* title, int width, int height, OutputCPP output = OutputCPP(Output.Default), ModeCPP mode = ModeCPP(Mode.FloatingPoint));
        } else {
            bool open(const char* title, int width, int height, OutputCPP output = OutputCPP(Output.Default), ModeCPP mode = ModeCPP(Mode.FloatingPoint));
            bool open() const;
        }
        void close();

        version(MSVC) {
            // msvc does some crazy sh*t, in case of open() above, it always
            // places ptrs in the vtbl in order he wants, in case of this one
            // however, he places ptrs (to title() and update()) always swaped
            // with what you declare o0
            bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null);
            bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null);

            void title(char* title);
            const char* title() const;
        } else {

            bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null);
            bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null);

            const char* title() const;
            void title(char* title);
        }
        int width() const;
        int height() const;

        version (MSVC) {
            void mode(ref ModeCPP data) const;
            void output(ref OutputCPP data) const;
        } else {
            ModeCPP mode() const;
            OutputCPP output() const;
        }

        void listener(ICppListener listener );
        ICppListener listener() const;

        void wrapper(IDisplay wrapper);
        IDisplay wrapper();
    }

    interface ITimer {
        void reset();
        double time();
        double delta();
        double resolution();
        void wait(double seconds);
    }


    IDisplay PixelToasterWrapper_createDisplay();
    void PixelToasterWrapper_destroyDisplay(void*);

    ITimer PixelToasterWrapper_createTimer();
    void PixelToasterWrapper_destroyTimer(void*);
}


