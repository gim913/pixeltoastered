module Fullscreen;

// Fullscreen Example.
// Opens a display for fullscreen output in floating point color mode.
// Part of the PixelToaster Framebuffer Library - http://www.pixeltoaster.com

import PixelToastereD;

const int width = 640;
const int height = 480;

int main()
{
    auto display = new Display("Fullscreen Example\0".ptr, width, height, Output.Fullscreen);
    FloatingPointPixel pixels[width * height];

    while (display.open()) {
        size_t index = 0;

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                pixels[index].r = 0.8f + y * 0.0015f;
                pixels[index].g = 0.2f + y * 0.00075f;
                pixels[index].b = 0.1f + y * 0.0005f;

                ++index;
            }
        }

        display.update(pixels.ptr);
    }

    return 0;
}
