#!/bin/bash
#

PIXEL_LOC=pixeltoaster-read-only
PATH=/opt/dmd2/dmd/linux/bin:$PATH
CXX_LINK_OPTS="-lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2"

g++ -O3 -DPLATFORM_UNIX -DPIXELTOASTER_TINY -c ${PIXEL_LOC}/PixelToaster.cpp -o PixelToasterCPP.o
g++ -O3 -I${PIXEL_LOC} -c PixelToasterWrapper.cpp

dmd -release -c PixelToastereD.d

dmd -release -c examples/FloatingPoint.d -ofexamples/FloatingPoint.o
g++ -O3 examples/FloatingPoint.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/FloatingPoint 

dmd -release -c examples/Fullscreen.d -ofexamples/Fullscreen.o
g++ -O3 examples/Fullscreen.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/Fullscreen

dmd -release -c examples/TrueColor.d -ofexamples/TrueColor.o
g++ -O3 examples/TrueColor.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/TrueColor

dmd -release -c examples/Image.d -ofexamples/Image.o
g++ -O3 examples/Image.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/Image

dmd -release -c examples/KeyaboardAndMouse.d -ofexamples/KeyaboardAndMouse.o
g++ -O3 examples/KeyaboardAndMouse.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/KeyaboardAndMouse

dmd -release -version=UseDListener -c PixelToastereD.d
dmd -release -version=UseDListener -c examples/KeyaboardAndMouseD.d -ofexamples/KeyaboardAndMouseD.o
g++ -O3 examples/KeyaboardAndMouseD.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/KeyaboardAndMouseD

dmd -release -version=UseDListener -c examples/MultiDisplay.d -ofexamples/MultiDisplay.o
g++ -O3 examples/MultiDisplay.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${CXX_LINK_OPTS} -o examples/MultiDisplay
