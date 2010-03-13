module examples.FloatingPoint;

// Floating Point Color.
// Pixels are float r,g,b,a values automatically clamped in range [0,1]

import PixelToastereD;

const int width = 640;
const int height = 480;

alias FloatingPointPixel Pixel;

int main() {
    auto display = new Display("Floating Point Example\0".ptr, width, height );
    Pixel pixels[width * height];

    while ( display.open() ) {
        size_t index = 0;
        for ( int y = 0; y < height; ++y ) {
            for ( int x = 0; x < width; ++x ) {
                pixels[index].r = 0.1f + (x + y) * 0.0008f;
                pixels[index].g = 0.5f + (x + y) * 0.0004f;
                pixels[index].b = 0.7f + (x + y) * 0.0002f;

                ++index;
            }
        }

        display.update(pixels.ptr);
    }
    return 0;
}
