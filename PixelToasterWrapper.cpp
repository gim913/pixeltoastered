#include "PixelToaster.h"

PixelToaster::DisplayInterface* PixelToasterWrapper_createDisplay()
{
		PixelToaster::DisplayInterface* ptr = PixelToaster::createDisplay();
		return ptr;
}

void PixelToasterWrapper_destroyDisplay(void* d)
{
		PixelToaster::DisplayInterface* r = (PixelToaster::DisplayInterface*)d;
		delete r;
}


PixelToaster::TimerInterface* PixelToasterWrapper_createTimer()
{
		PixelToaster::TimerInterface* ptr = PixelToaster::createTimer();
		return ptr;
}

void PixelToasterWrapper_destroyTimer(void* d)
{
		PixelToaster::TimerInterface* r = (PixelToaster::TimerInterface*)d;
		delete r;
}
