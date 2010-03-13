module examples.TrueColor;

// TrueColor Example
// How to open a display in truecolor mode and work with 32 bit integer pixels.

import PixelToastereD;

const int width = 640;
const int height = 480;

alias TrueColorPixel Pixel;

int main() {
    auto display = new Display("TrueColor Example\0".ptr, width, height, Output.Default, Mode.TrueColor);
    Pixel pixels[width * height];

    while (display.open()) {
        size_t index = 0;

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                pixels[index].r = cast(ubyte)(x < 255 ? x : 255);
                pixels[index].g = cast(ubyte)(y < 255 ? y : 255);
                pixels[index].b = cast(ubyte)(256-(x+y) > 0 ? 256-(x+y) : 0);

                ++index;
            }
        }

        display.update(pixels.ptr);
    }

    return 0;
}
