module examples.Image;

// Image example
// Demonstrates how to load and display a TGA image

import PixelToastereD;
import std.stdio : write;
import std.stream;

alias TrueColorPixel Pixel;

int main() {
    int width, height;
    Pixel[] pixels;

    pixels = load([ "ExampleImage.tga", "../ExampleImage.tga" ], width, height);
    if (pixels is null) {
        write ("couldn't load file\n");
        return 1;
    }

    auto display = new Display("Image Example\0".ptr, width, height);

    while (display.open()) {
        display.update(pixels.ptr);
    }

    return 0;
}


Pixel[] load(string[] names, ref int width, ref int height) {
    Pixel[] pixels;
    foreach (name; names) {
        try {
            pixels = realLoad(name, width, height);
            break;
        } catch { }
    }
    return pixels;
}

Pixel[] realLoad(string filename, ref int width, ref int height)
{
    scope file = new File(filename);

    TgaHeader  header;
    file.readExact(cast(void*)(&header), header.sizeof);

    if (header.imageType != TgaHeader.UncompressedTrueColor) {
        throw new TgaException("Tga must be uncompressed true color image");
    }
    if (header.bpp != 24) {
        throw new TgaException("Only 24bpp tga images supported");
    }

    width = header.width;
    height = header.height;
    if (width * height > 60*1024*1024) {
        throw new TgaException("Tga image has suspiciously big dimensions");
    }

    ubyte[] buffer;
    buffer.length = width * height * 3;
    file.read(buffer);

    Pixel[] pixels;
    pixels.length = width * height;
    size_t index = 0;
    foreach (ref pixel; pixels) {
        pixel.b = buffer[index++];
        pixel.g = buffer[index++];
        pixel.r = buffer[index++];
    }

    return pixels;
}

align(1) struct TgaHeader {
    ubyte  idLen;
    ubyte  colorMap;
    ubyte  imageType;
    ushort palStart;
    ushort palLen;
    ubyte  palBitsPerColor;
    ushort xOrigin;
    ushort yOrigin;
    ushort _width;
    ushort _height;
    ubyte  bpp;
    ubyte  flags;

    ushort width() {
        version (LittleEndian) {
            return _width;
        } else {
            return cast(ushort)((_width << 8) | (_width >> 8));
        }
    }

    ushort height() {
        version (LittleEndian) {
            return _height;
        } else {
            return cast(ushort)((_height << 8) | (_height >> 8));
        }
    }

    enum {
        NoImageData = 0,
        UncompressedColorMapped = 1,
        UncompressedTrueColor = 2,
        UncompressedBlackWhite = 3,
        RLEColorMapped = 9,
        RLETrueColor = 10,
        RLEBlackWhite = 11
    }
}

class TgaException : Exception {
    this(string str) { super(str); }
}


