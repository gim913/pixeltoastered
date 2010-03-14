module examples.Timer;

// this example is a D port of similar example from pixeltoaster library
// this example as original pixeltoaster's examples can be redistributed
// using BSD-style license, see license-notice.txt for information

// Timer Example
// D port of original example by:
// Copyright (c) 2004-2007 Glenn Fiedler

import PixelToastereD;
import std.stdio;


int main() {
    writeln ("\n[ Timer Example ]\n");

    auto timer = new Timer;

    writeln ("theoretical timer resolution is ", 1e6*timer.resolution, " microseconds\n");
    timer.delta();
    writeln ("practical timer resolution is ", 1e6*timer.delta, " microseconds\n");

    writeln ("waiting for one second...");

    const double waitStart = timer.time();
    timer.wait(1.0);
    const double waitFinish = timer.time();

    writeln (waitFinish - waitStart, " seconds elapsed according to timer\n");

    writeln ("loop time + delta...");
    
    timer.reset();

    for (int i = 0; i < 5; ++i) {
        timer.wait(0.1f);
        const double time = timer.time();
        const double delta = timer.delta();
        writeln ("  time = ", time, ", delta = ", delta );
    }

    writeln ("\nloop delta only...");

    timer.reset();
    for (int i = 0; i < 5; ++i) {
        timer.wait(0.1f);
        const double delta = timer.delta();
        writeln ("  delta = ", delta );
    }

    writeln ("\ndone.\n");
    return 0;
}
