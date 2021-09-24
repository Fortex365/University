#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <iostream>


int main(int argc, char** argv) {

	char cmdline[100];
	strcpy(cmdline, argv[1]);
	strcat(cmdline, " ");
	strcat(cmdline, argv[2]);

	// https://docs.microsoft.com/en-us/windows/win32/procthread/creating-processes
	STARTUPINFOA si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));

	// Start the child process. 
	if (!CreateProcess("C:\\Users\\Luky\\Documents\\University\\Operaèní systémy 2\\Ukoly\\OS2-01\\Debug\\OS2-01.exe",   // No module name (use command line)
		cmdline,        // Command line
		NULL,           // Process handle not inheritable
		NULL,           // Thread handle not inheritable
		FALSE,          // Set handle inheritance to FALSE
		0,              // No creation flags
		NULL,           // Use parent's environment block
		NULL,           // Use parent's starting directory 
		&si,            // Pointer to STARTUPINFO structure
		&pi)           // Pointer to PROCESS_INFORMATION structure
		)
	{
		printf("CreateProcess failed (%d).\n", GetLastError());
		return -1;
	}


	// Wait until child process exits.
	WaitForSingleObject(pi.hThread, INFINITE);

	// Close process and thread handles. 
	//CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
	Sleep(4000);
	return 0;
}