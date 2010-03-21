module examples.KeyboardAndMouseD;

// this example is a D port of similar example from pixeltoaster library
// this example as original pixeltoaster's examples can be redistributed
// using BSD-style license, see license-notice.txt for information

// Keyboard and Mouse Example
// How to get keyboard and mouse events from a display

import PixelToastereD;

import std.stdio;

class ExampleListener : protected Listener {
protected:
    override
    bool defaultKeyHandlers() const {
        return true;
    }
    override
    void onKeyDown(IDisplay display, Key key) { 
        writeln ("key down=", key, " ", getKeyString(key));
        stdout.flush();	
    }
    override
    void onKeyPressed(IDisplay display, Key key) { 
        writeln ("key pressed=", key, " ", getKeyString(key));
        stdout.flush();	
    }
    override
    void onKeyUp(IDisplay display, Key key) { 
        writeln ("key up=", key, " ", getKeyString(key));
        stdout.flush();	
    }
    override
    void onMouseButtonDown(IDisplay display, Mouse mouse) { 
        writeln ("mouse down ", mouse.buttons.left?1:0, mouse.buttons.middle?1:0, mouse.buttons.right?1:0);
        stdout.flush();	
    }
    override
    void onMouseButtonUp(IDisplay display, Mouse mouse) { 
        writeln ("mouse up ", mouse.x, ", ", mouse.y);
        stdout.flush();	
    }
    override
    void onMouseMove(IDisplay display, Mouse mouse) { 
        writeln ("mouse move ", mouse.x, ", ", mouse.y);
        stdout.flush();	
    }
    override
    void onActivate(IDisplay display, bool active) { 
        writeln ("activate?"); 
        stdout.flush();	
    }
    override
    void onOpen(IDisplay display) {
        writeln ("onopen?");
        stdout.flush();	
    }
    override
    bool onClose(IDisplay display) {
        writeln ("onclose");
        stdout.flush();	
        return true; 
    }
}

class Application {
    static const int width = 640;
    static const int height = 480;
    Display display;

    alias FloatingPointPixel Pixel;
    Pixel[width*height] pixels;

    static Application _inst;
    this() { display = new Display; }

    public:
    static Application getInstance() { 
        if (Application._inst is null) {
            Application._inst = new Application(); 
        }
        return _inst;
    }
    
    int run() {
        auto foobar = new ExampleListener;
        display.listener(foobar);

        if (!display.open("Keyboard and Mouse Example (using DListener)\0".ptr, width, height))
            return 1;

        while (display.open()) {
            size_t index = 0;

            for (int y = 0; y < height; ++y) {
                for (int x = 0; x < width; ++x) {
                    pixels[index].r = 0.3f + (x + y) * 0.00075f;
                    pixels[index].g = 0.7f + (x + y) * 0.000f;
                    pixels[index].b = 0.5f + (x + y) * 0.0004f;

                    ++index;
                }
            }

            display.update(pixels.ptr);
        }

        return 0;
    }

};


int main() {
    Application.getInstance().run();
    return 0;
}


pure string getKeyString(Key key)
{
    switch (key)
    {
        case Key.Enter:        return "Enter";
        case Key.BackSpace:    return "BackSpace";
        case Key.Tab:          return "Tab";
        case Key.Cancel:       return "Cancel";
        case Key.Clear:        return "Clear";
        case Key.Shift:        return "Shift";
        case Key.Control:      return "Control";
        case Key.Alt:          return "Alt";
        case Key.Pause:        return "Pause";
        case Key.CapsLock:     return "CapsLock";
        case Key.Escape:       return "Escape";
        case Key.Space:        return "Space";
        case Key.PageUp:       return "PageUp";
        case Key.PageDown:     return "PageDown";
        case Key.End:          return "End";
        case Key.Home:         return "Home";
        case Key.Left:         return "Left";
        case Key.Up:           return "Up";
        case Key.Right:        return "Right";
        case Key.Down:         return "Down";
        case Key.Comma:        return "Comma";
        case Key.Period:       return "Period";
        case Key.Slash:        return "Slash";
        case Key.Zero:         return "Zero";
        case Key.One:          return "One";
        case Key.Two:          return "Two";
        case Key.Three:        return "Three";
        case Key.Four:         return "Four";
        case Key.Five:         return "Five";
        case Key.Six:          return "Six";
        case Key.Seven:        return "Seven";
        case Key.Eight:        return "Eight";
        case Key.Nine:         return "Nine";
        case Key.SemiColon:    return "SemiColon";
        case Key.Equals:       return "Equals";
        case Key.A:            return "A";
        case Key.B:            return "B";
        case Key.C:            return "C";
        case Key.D:            return "D";
        case Key.E:            return "E";
        case Key.F:            return "F";
        case Key.G:            return "G";
        case Key.H:            return "H";
        case Key.I:            return "I";
        case Key.J:            return "J";
        case Key.K:            return "K";
        case Key.L:            return "L";
        case Key.M:            return "M";
        case Key.N:            return "N";
        case Key.O:            return "O";
        case Key.P:            return "P";
        case Key.Q:            return "Q";
        case Key.R:            return "R";
        case Key.S:            return "S";
        case Key.T:            return "T";
        case Key.U:            return "U";
        case Key.V:            return "V";
        case Key.W:            return "W";
        case Key.X:            return "X";
        case Key.Y:            return "Y";
        case Key.Z:            return "Z";
        case Key.OpenBracket:  return "OpenBracket";
        case Key.BackSlash:    return "BackSlash";
        case Key.CloseBracket: return "CloseBracket";
        case Key.NumPad0:      return "NumPad0";
        case Key.NumPad1:      return "NumPad1";
        case Key.NumPad2:      return "NumPad2";
        case Key.NumPad3:      return "NumPad3";
        case Key.NumPad4:      return "NumPad4";
        case Key.NumPad5:      return "NumPad5";
        case Key.NumPad6:      return "NumPad6";
        case Key.NumPad7:      return "NumPad7";
        case Key.NumPad8:      return "NumPad8";
        case Key.NumPad9:      return "NumPad9";
        case Key.Multiply:     return "Multiply";
        case Key.Add:          return "Add";
        case Key.Separator:    return "Separator";
        case Key.Subtract:     return "Subtract";
        case Key.Decimal:      return "Decimal";
        case Key.Divide:       return "Divide";
        case Key.F1:           return "F1";
        case Key.F2:           return "F2";
        case Key.F3:           return "F3";
        case Key.F4:           return "F4";
        case Key.F5:           return "F5";
        case Key.F6:           return "F6";
        case Key.F7:           return "F7";
        case Key.F8:           return "F8";
        case Key.F9:           return "F9";
        case Key.F10:          return "F10";
        case Key.F11:          return "F11";
        case Key.F12:          return "F12";
        case Key.Delete:       return "Delete";
        case Key.NumLock:      return "NumLock";
        case Key.ScrollLock:   return "ScrollLock";
        case Key.PrintScreen:  return "PrintScreen";
        case Key.Insert:       return "Insert";
        case Key.Help:         return "Help";
        case Key.Meta:         return "Meta";
        case Key.BackQuote:    return "BackQuote";
        case Key.Quote:        return "Quote";
        case Key.Final:        return "Final";
        case Key.Convert:      return "Convert";
        case Key.NonConvert:   return "NonConvert";
        case Key.Accept:       return "Accept";
        case Key.ModeChange:   return "ModeChange";
        case Key.Kana:         return "Kana";
        case Key.Kanji:        return "Kanji";
        default:               return "Undefined";
    }
}

