module PixelToastereD;

enum Output { Default, Windowed, Fullscreen }
enum Mode { TrueColor, FloatingPoint }

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
    IDisplay internal;
    public:
    this() {
        internal = PixelToasterWrapper_createDisplay();
        //internal.wrapper(this);
    }

    this(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint) {
        internal  = PixelToasterWrapper_createDisplay();
        //internal.wrapper( this );
        open( title, width, height, output, mode );
    }

    ~this() {
        if (internal) {
            PixelToasterWrapper_destroyDisplay(cast(void*)internal);
            internal = null;
        }
    }

    bool open(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint ) {
        if (internal) {
            return internal.open( title, width, height, output, mode );
        }
        return false;
    }

    void close() {
        if (internal) {
            internal.close();
        }
    }

    bool open() {
        if (internal) {
            return internal.open();
        }
        return false;
    }

    bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null) {
        if (internal) {
            return internal.update( pixels, dirtyBox );
        }
        return false;
    }

    bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null) {
        if (internal) {
            return internal.update( pixels, dirtyBox );
        }
        return false;
    }

    char* title() {
        if (internal) {
            return internal.title();
        }
        return "\0".dup.ptr;
    }

    void title(char* title) {
        if (internal) {
            internal.title(title);
        }
    }

    int width() {
        if (internal) {
            return internal.width();
        }
        return 0;
    }

    int height() {
        if (internal) {
            return internal.height();
        }
        return 0;
    }

    Mode mode() {
        if (internal) {
            return internal.mode();
        }
        return Mode.FloatingPoint;
    }

    Output output() {
        if (internal) {
            return internal.output();
        }
        return Output.Default;
    }

    void wrapper(IDisplay wrapper ) { }

    IDisplay wrapper() {
        return null;
    }
}

class Timer {
    ITimer internal;
    public:

    this() {
        internal = PixelToasterWrapper_createTimer();
    }

    ~this() {
        PixelToasterWrapper_destroyTimer(cast(void*)internal);
        internal = null;
    }

    void reset() {
        if (internal) {
            internal.reset;
        }
    }

    double time() {
        if (internal) {
            return internal.time;
        }
        return 0.0;
    }

    double delta() {
        if (internal) {
            return internal.delta;
        }
        return 0.0;
    }

    double resolution() {
        if (internal) {
            return internal.resolution;
        }
        return 0.0;
    }

    void wait(double seconds) {
        if (internal) {
            internal.wait(seconds);
        }
    }
}


extern (C++) {
    interface Listener { 
        bool defaultKeyHandlers();
    }

    interface IDisplay {
        bool open(const char* title, int width, int height, Output output = Output.Default, Mode mode = Mode.FloatingPoint );
        void close();

        bool open() const;

        bool update(FloatingPointPixel* pixels, Rectangle* dirtyBox = null);
        bool update(TrueColorPixel* pixels, Rectangle* dirtyBox = null);

        const char* title() const;
        void title(char* title);
        int width() const;
        int height() const;
        Mode mode() const;
        Output output() const;

        void listener(Listener listener );
        Listener listener() const;

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


