#include <windows.h>
#include <string>
#include <iostream>
#include <assert.h>
#include <fstream>
#include <vector>
using namespace std;

// Global variable inicializations
CRITICAL_SECTION readLock;
CRITICAL_SECTION writeLock;

char* filter = new char[50];
char filterLength;
ifstream rFile;
ofstream wFile;
int rowIdx = 0;


DWORD hledat()
{
	// Variable inicializations
	int readCnt = 0;
	int writeCnt = 0;
	char nameLength;
	char* name = new char[50];
	bool passed;

	while (true)
	{
		// Entering CS for reading
		EnterCriticalSection(&readLock);

		// Case when we should leave immediatelly
		if (!rFile.good() ||
			rFile.eof())
		{
			LeaveCriticalSection(&readLock);
			break;
		}

		// Read the length of the name
		rFile.read(&nameLength, 1);
		// Use that length to read the name
		rFile.read(name, nameLength);
		// Leaving CS for reading
		LeaveCriticalSection(&readLock);

		name[nameLength] = '\0';
		// After success reading
		readCnt++;

		// Prefix cannot be larger than the name
		if (nameLength < filterLength)
			continue;

		// Checking of word succeeded in prefix filter
		passed = true;
		for (char c = 0; c < filterLength; c++) 
		{
			if (toupper(filter[c]) != toupper(name[c]))
			{
				passed = false;
				break;
			}
		}

		// Then we can enter write CS
		if (passed)
		{
			EnterCriticalSection(&writeLock);
			// Write the found name according to the prefix
			wFile << name;
			// Structure the writing file into blocks of 10
			if (++rowIdx % 10 == 0)
			{
				wFile << '\n';
			}
			else {
				wFile << ' ';
			}
			// Raise the write counter since we already wrote it into file
			writeCnt++;
			// Finally leave writing CS
			LeaveCriticalSection(&writeLock);
		}
	}
	
	// Returning out of thread with result
	return ((readCnt << 16) |
		writeCnt);
}


int main(int argc, char** argv)
{
	int ZAPSANYCH = 0xFFFF;

	// Input prefix from keyboard
	cout << "Zadejte prefix: ";
	cin >> filter;
	filterLength = strlen(filter);

	// Initialize critical sections
	InitializeCriticalSection(&readLock);
	InitializeCriticalSection(&writeLock);

	// Thread handles
	HANDLE thrds[2];

	// Creates and checks if threads were assigned successfully
	thrds[0] = CreateThread(NULL, 0,
		(LPTHREAD_START_ROUTINE)&hledat,
		NULL, CREATE_SUSPENDED, NULL);

	if (NULL == thrds[0])
	{
		cout << "Thread creation failed" << endl;
		return -1;
	}

	thrds[1] = CreateThread(NULL, 0,
		(LPTHREAD_START_ROUTINE)&hledat,
		NULL, CREATE_SUSPENDED, NULL);

	if (NULL == thrds[1])
	{
		cout << "Thread creation failed" << endl;
		return -1;
	}

	// File handling
	rFile.open("JmenaB", ios::binary);
	wFile.open("JmenaX", ios::out);

	// Checking proper file opening
	if (!rFile.is_open() ||
		!wFile.is_open())
	{
		cout << "Nepodarilo se otevrit soubor!" << endl;
		return -1;
	}

	// Starts the threads
	ResumeThread(thrds[0]);
	ResumeThread(thrds[1]);

	// Waits for thread creation
	WaitForMultipleObjects(2, thrds, TRUE, INFINITE);
	assert(thrds[0] && thrds[1]);

	// Returning exit codes of each thread
	DWORD resultThread1;
	GetExitCodeThread(thrds[0], &resultThread1);
	DWORD resultThread2;
	GetExitCodeThread(thrds[1], &resultThread2);

	// Outputting the results
	cout << "Thread-1 " << " Prectenych: " << (resultThread1 >> 16) <<
		" Zapsanych: " << (resultThread1 & ZAPSANYCH) << endl;
	cout << "Thread-2 " << " Prectenych: " << (resultThread2 >> 16) <<
		" Zapsanych: " << (resultThread2 & ZAPSANYCH) << endl;

	// Closing thread handles
	CloseHandle(thrds[0]);
	CloseHandle(thrds[1]);

	// Closing critical section
	DeleteCriticalSection(&readLock);
	DeleteCriticalSection(&writeLock);

	// Closing main process
	ExitProcess(0);
}
