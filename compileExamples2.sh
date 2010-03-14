#!/bin/bash
#
# This is alternative build script using dmd for linking

PIXEL_LOC=pixeltoaster-read-only
PATH=/opt/dmd2/dmd/linux/bin:$PATH
LINK=dmd
LINK_OPTS="-L-lstdc++ -L-lrt -L-lX11"

#g++ -O3 -DPLATFORM_UNIX -DPIXELTOASTER_TINY -c ${PIXEL_LOC}/PixelToaster.cpp -o PixelToasterCPP.o
#g++ -O3 -I${PIXEL_LOC} -c PixelToasterWrapper.cpp

#${LINK} -release -ofexamples/FloatingPoint examples/FloatingPoint.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS}

#${LINK} -release -ofexamples/Fullscreen examples/Fullscreen.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS}

#${LINK} -release -ofexamples/TrueColor examples/TrueColor.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

#${LINK} -release -ofexamples/Image examples/Image.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

#${LINK} -release -ofexamples/KeyaboardAndMouse examples/KeyaboardAndMouse.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

#${LINK} -release -version=UseDListener -ofexamples/KeyaboardAndMouseD examples/KeyaboardAndMouseD.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

#${LINK} -release -version=UseDListener -ofexamples/MultiDisplay examples/MultiDisplay.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 

${LINK} -release -version=UseDListener -ofexamples/PlasmaEffect examples/PlasmaEffect.d PixelToastereD.d PixelToasterWrapper.o PixelToasterCPP.o ${LINK_OPTS} 
