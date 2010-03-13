#!/bin/bash
#

PIXEL_LOC=pixeltoaster-read-only

g++ -O3 -DPLATFORM_UNIX -DPIXELTOASTER_TINY -c ${PIXEL_LOC}/PixelToaster.cpp -o PixelToasterCPP.o
g++ -O3 -I${PIXEL_LOC} -c PixelToasterWrapper.cpp
#rebuild -clean GiMTest.d PixelToasterWrapper.o PixelToasterCPP.o -L-lstdc++ -L-lrt -L-lX11
/opt/dmd2/dmd/linux/bin/dmd -release -I/home/gim/uczelnia/D -c GiMTest.d
/opt/dmd2/dmd/linux/bin/dmd -release -c PixelToastereD.d
#/opt/dmd2/dmd/linux/bin/dmd -release -version=Phobos -I/home/gim/uczelnia/D -c /home/gim/uczelnia/D/xf/omg/core/LinearAlgebra.d
#/opt/dmd2/dmd/linux/bin/dmd -release -c /home/gim/uczelnia/D/xf/omg/core/Algebra.d
g++ -O3 GiMTest.o PixelToastereD.o PixelToasterWrapper.o PixelToasterCPP.o -lstdc++ -lrt -lX11 -L/opt/dmd2/dmd/linux/lib -lphobos2 -o GiMTest
