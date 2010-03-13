#!/bin/bash
#

PIXEL_LOC=pixeltoaster-read-only

g++ -O3 -DPLATFORM_UNIX -DPIXELTOASTER_TINY -c ${PIXEL_LOC}/PixelToaster.cpp -o PixelToasterCPP.o
g++ -O3 -I${PIXEL_LOC} -c PixelToasterWrapper.cpp

/opt/dmd2/dmd/linux/bin/dmd -release -c PixelToastereD.d

/opt/dmd2/dmd/linux/bin/dmd -release -c examples/FloatingPoint.d -ofexamples/FloatingPoint.o
g++ -O3 examples/FloatingPoint.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o examples/FloatingPoint

/opt/dmd2/dmd/linux/bin/dmd -release -c examples/Fullscreen.d -ofexamples/Fullscreen.o
g++ -O3 examples/Fullscreen.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o examples/Fullscreen

/opt/dmd2/dmd/linux/bin/dmd -release -c examples/TrueColor.d -ofexamples/TrueColor.o
g++ -O3 examples/TrueColor.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o examples/TrueColor

/opt/dmd2/dmd/linux/bin/dmd -release -c examples/Image.d -ofexamples/Image.o
g++ -O3 examples/Image.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o examples/Image

/opt/dmd2/dmd/linux/bin/dmd -release -c examples/KeyaboardAndMouse.d -ofexamples/KeyaboardAndMouse.o
g++ -O3 examples/KeyaboardAndMouse.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o examples/KeyaboardAndMouse
