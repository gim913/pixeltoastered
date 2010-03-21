#!/bin/bash

rm -rf /tmp/PixelToastereDCompile
hg ci -m 'temporary commit'
cd ..
hg clone PixelToastereD /tmp/PixelToastereDCompile
cp -r PixelToastereD/pixeltoaster-read-only-orig/ /tmp/PixelToastereDCompile/pixeltoaster-read-only
cd -
cd /tmp/PixelToastereDCompile
patch -p0 < pixeltoasterInD.patch
./compileExamples2.sh
cd -
hg rollback
