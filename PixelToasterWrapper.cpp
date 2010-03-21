#include "PixelToaster.h"

#if defined(PLATFORM_WINDOWS)
#include <stdio.h>
#include <windows.h>

// TODO: fix this, it's ugly :P
HANDLE hLib;
typedef PixelToaster::DisplayInterface* (*CreateDisplayDef)();
typedef PixelToaster::TimerInterface* (*CreateTimerDef)();
CreateDisplayDef createDisplayPtr = NULL;
CreateTimerDef createTimerPtr = NULL;

int retrievePointers();
#endif

class IDisplay {
	public:
		virtual void foobar();
};

class ITimer { 
	public:
		virtual void foobar();
};

IDisplay* PixelToasterWrapper_createDisplay()
{
#if defined(PLATFORM_UNIX)
	PixelToaster::DisplayInterface* ptr = PixelToaster::createDisplay();
#elif defined(PLATFORM_WINDOWS)
	if (retrievePointers()) {
		return NULL;
	}
	PixelToaster::DisplayInterface* ptr = (*createDisplayPtr)();
#endif
	return (IDisplay*)ptr;
}

void PixelToasterWrapper_destroyDisplay(void* d)
{
	PixelToaster::DisplayInterface* r = (PixelToaster::DisplayInterface*)d;
	delete r;
}

ITimer* PixelToasterWrapper_createTimer()
{
#if defined(PLATFORM_UNIX)
	PixelToaster::TimerInterface* ptr = PixelToaster::createTimer();
#elif defined(PLATFORM_WINDOWS)
	if (retrievePointers()) {
		return NULL;
	}
	PixelToaster::TimerInterface* ptr = (*createTimerPtr)();
#endif
	return (ITimer*)ptr;
}

void PixelToasterWrapper_destroyTimer(void* d)
{
	PixelToaster::TimerInterface* r = (PixelToaster::TimerInterface*)d;
	delete r;
}



#if defined(PLATFORM_WINDOWS)
int retrievePointers() {
	if (! hLib) {
		hLib = LoadLibrary("pixeltoaster.dll");
	}
	if (NULL == hLib) {
		return 1;
	}

	// pointers already resolved
	if (createDisplayPtr && createTimerPtr) {
		return 0;
	}
	createTimerPtr = NULL;
	createDisplayPtr = NULL;

	// instead of tyring to find given symbol, we'll
	// parse dll, and try to find out symbol in exported
	// symbols table

	// i won't be using dbghelp api I'll try to parse headers
	// in mem
	IMAGE_DOS_HEADER& dosHead = *(PIMAGE_DOS_HEADER)hLib;
	if ( IMAGE_DOS_SIGNATURE != dosHead.e_magic) {
		return 1;
	}

	IMAGE_NT_HEADERS& peHead = *(PIMAGE_NT_HEADERS)(dosHead.e_lfanew + (char*)hLib);
	if ( IMAGE_NT_SIGNATURE != peHead.Signature ) {
		return 1;
	}

	// calculate the minimal size of optional headers
	// that we need and check it...
	const size_t minOpt = sizeof(IMAGE_OPTIONAL_HEADER) - IMAGE_NUMBEROF_DIRECTORY_ENTRIES*sizeof(IMAGE_DATA_DIRECTORY) + (IMAGE_DIRECTORY_ENTRY_EXPORT+1)*sizeof(IMAGE_DATA_DIRECTORY);
	if (peHead.FileHeader.SizeOfOptionalHeader < minOpt) {
		return 1;
	}
	
	IMAGE_DATA_DIRECTORY& expDD = peHead.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];

	DWORD SOI = peHead.OptionalHeader.SizeOfImage;
	// check if it's not outside loaded image
	if (expDD.VirtualAddress >= SOI) {
		return 1;
	}

	// we can go to exportDir :)
	IMAGE_EXPORT_DIRECTORY& exportDir = *(PIMAGE_EXPORT_DIRECTORY)(expDD.VirtualAddress + (char*)hLib);

	// there mus be at least two names, one for createTimer, one for createDisplay
	if (exportDir.NumberOfNames < 2 || exportDir.NumberOfFunctions < 2) {
		return 1;
	}

	// XXX: warning, here are nasty casts, but since all
	// of these are RVAs it should be ok to cast it to dword ;p 
	DWORD AONO =  (DWORD)exportDir.AddressOfNameOrdinals;
	DWORD AON = (DWORD)exportDir.AddressOfNames;
	DWORD AOF = (DWORD)exportDir.AddressOfFunctions;
	if (AONO >= SOI || AON >= SOI) {
		return 1;
	}

	/* printf ("expdd: %08x | %08x %08x %08x\n", expDD.VirtualAddress, exportDir.NumberOfNames, exportDir.NumberOfFunctions, AONO); */
	WORD* ords = (WORD*)(AONO + (char*)hLib);
	DWORD* names = (DWORD*)(AON + (char*)hLib);
	DWORD* func = (DWORD*)(AOF + (char*)hLib);
	// find the name we're looking for...
	for (int i = 0; i < exportDir.NumberOfNames; i++) {
		// this is bad so we'll better break
		if (names[i] >= SOI || ords[i] >= exportDir.NumberOfFunctions) {
			return 1;
		}
		char* name = (char*)hLib + names[i];
		int nameLen = lstrlenA(name);
		if (nameLen < 6) {
			continue;
		}
		/* printf ("%04x - %08x - %08x - %s\n", ords[i], names[i], func[ords[i]], name); */
		// this sux, but I'm lazy :P
		for (int j = 0; j < nameLen - 6; j++) {
			if ((nameLen-j >= 13) && CSTR_EQUAL == CompareStringA(0, NORM_IGNORECASE, "createDisplay", 13, name + j, 13)) {
				/* printf ("great we have a match at pos %d\n", j); */
				createDisplayPtr = (CreateDisplayDef)((char*)hLib + func[ords[i]]);
			}
			if ((nameLen-j >= 11) && CSTR_EQUAL == CompareStringA(0, NORM_IGNORECASE, "createTimer", 11, name + j, 11)) {
				/* printf ("great we have a match at pos %d\n", j); */
				createTimerPtr = (CreateTimerDef)((char*)hLib + func[ords[i]]);
			}
			if (createTimerPtr && createDisplayPtr) {
				/* printf ("pointers: %08x %08x\n", createTimerPtr, createDisplayPtr); */
				return 0;
			}
		}
	}
	return 1;
}
#endif
