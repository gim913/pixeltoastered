#!/bin/bash
#

PIXEL_LOC=pixeltoaster-read-only
PATH=/opt/dmd2/dmd/linux/bin:$PATH
LINK=g++
LINK_OPTS="-lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2"
LINK_OUT="-o"

g++ -O3 -DPLATFORM_UNIX -DPIXELTOASTER_TINY -c ${PIXEL_LOC}/PixelToaster.cpp -o PixelToasterCPP.o
g++ -O3 -I${PIXEL_LOC} -c PixelToasterWrapper.cpp

dmd -release -c PixelToastereD.d

dmd -release -c examples/FloatingPoint.d -ofexamples/FloatingPoint.o
${LINK} ${LINK_OUT}examples/FloatingPoint examples/FloatingPoint.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS}

dmd -release -c examples/Fullscreen.d -ofexamples/Fullscreen.o
${LINK} ${LINK_OUT}examples/Fullscreen examples/Fullscreen.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

dmd -release -c examples/TrueColor.d -ofexamples/TrueColor.o
${LINK} ${LINK_OUT}examples/TrueColor examples/TrueColor.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

dmd -release -c examples/Image.d -ofexamples/Image.o
${LINK} ${LINK_OUT}examples/Image examples/Image.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

dmd -release -c examples/KeyaboardAndMouse.d -ofexamples/KeyaboardAndMouse.o
${LINK} ${LINK_OUT}examples/KeyaboardAndMouse examples/KeyaboardAndMouse.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

dmd -release -version=UseDListener -c PixelToastereD.d
dmd -release -version=UseDListener -c examples/KeyaboardAndMouseD.d -ofexamples/KeyaboardAndMouseD.o
${LINK} ${LINK_OUT}examples/KeyaboardAndMouseD examples/KeyaboardAndMouseD.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

dmd -release -version=UseDListener -c examples/MultiDisplay.d -ofexamples/MultiDisplay.o
${LINK} ${LINK_OUT}examples/MultiDisplay examples/MultiDisplay.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 
