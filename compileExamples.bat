@echo off

SET PIXELLOC=pixeltoaster-read-only

PATH=c:/dmd2/windows/bin;%PATH

copy %PIXELLOC%\build\PixelToaster.dll .
copy %PIXELLOC%\build\PixelToaster.dll examples

del PixelToasterWrapper.obj
c:\dm\bin\dmc.exe -I%PIXELLOC% -DPIXELTOASTER_TINY -DPLATFORM_WINDOWS -c PixelToasterWrapper.cpp

if exist PixelToasterWrapper.obj (
	dmd.exe -debug -version=MSVC -ofexamples\FloatingPoint examples\FloatingPoint.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -ofexamples\Fullscreen examples\Fullscreen.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -ofexamples\TrueColor examples\TrueColor.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -ofexamples\Image examples\Image.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -ofexamples\KeyaboardAndMouse examples\KeyaboardAndMouse.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -version=UseDListener -ofexamples\KeyaboardAndMouseD examples\KeyaboardAndMouseD.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -version=UseDListener -ofexamples\MultiDisplay examples\MultiDisplay.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -version=UseDListener -ofexamples\PlasmaEffect examples\PlasmaEffect.d PixelToastered.d PixelToasterWrapper.obj

	dmd.exe -debug -version=MSVC -ofexamples\Timer examples\Timer.d PixelToastered.d PixelToasterWrapper.obj
)

