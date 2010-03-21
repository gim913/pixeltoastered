module examples.MultiDisplay;

// this example is a D port of similar example from pixeltoaster library
// this example as original pixeltoaster's examples can be redistributed
// using BSD-style license, see license-notice.txt for information

// Multiple Displays Example.
// Demonstrates how to open and update multiple displays.

import PixelToastereD;

import std.stdio;
import std.c.string;

const int width = 400;
const int height = 300;

alias FloatingPointPixel Pixel;

class MultiDisplayListener : protected Listener {
protected:
    void onOpen(IDisplay display) {
        const char* t = display.title();
        writeln ("open: ", t[0 .. strlen(t)]);
        stdout.flush();
    }

    bool onClose(IDisplay display) {
        const char* t = display.title();
        writeln ("close: ", t[0 .. strlen(t)]);
        stdout.flush();
        return true;
    }

    void onMouseMove(IDisplay display, Mouse mouse) {
        const char* t = display.title();
        writeln  (t[0 .. strlen(t)], "mouse move (", mouse.x, ",",mouse.y, ")\n"); 
        stdout.flush();
    }
}

int main() {
    auto listener = new MultiDisplayListener();
    auto d = [ new Display, new Display, new Display ];
    auto t = [ "Display A\0".ptr, "Display B\0".ptr, "Display C\0".ptr ];

    foreach (idx, disp; d) {
        disp.listener(listener);
        disp.open(t[idx], width, height);
    }

    Pixel[] pixels;
    pixels.length = width*height;

    while (d[0].open || d[1].open || d[2].open) {
        size_t index = 0;

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                pixels[index].r = 0.1f + (x + y) * 0.0015f;
                pixels[index].g = 0.5f + (x + y) * 0.001f;
                pixels[index].b = 0.7f + (x + y) * 0.0005f;

                ++index;
            }
        }

        foreach (disp; d) {
            if (disp.open) {
                disp.update(pixels.ptr);
            }
        }
    }
    return 0;
}
