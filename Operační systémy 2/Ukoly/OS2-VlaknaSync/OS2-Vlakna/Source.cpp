#include <windows.h>
#include <string>
#include <iostream>
#include <assert.h>
#include <fstream>
#include <vector>
using namespace std;

CRITICAL_SECTION readLock;
CRITICAL_SECTION writeLock;

struct tParam
{
	const char* soubor, * filtr;
};

string str_to_upper(string str) {
	/* Converting string to all uppercase characters */
	string ret;
	for (unsigned int i = 0; i < str.length(); i++) {
		ret += toupper(str[i]);
	}
	return ret;
}

bool same_prefix(string word, string prefix) {
	/* Check for if a given word has an given prefix */
	if (prefix.length() > word.length()) {
		return false;
	}
	for (unsigned int i = 0; i < prefix.length(); i++) {
		if (word[i] != prefix[i]) {
			return false;
		}
	}
	return true;
}

DWORD WINAPI hledat(CONST LPVOID prefix) {
	// Result of thread
	unsigned int resultCount = 0;

	// Unpacking the arguments from the address
	tParam arg = *((tParam*)prefix);
	string filePath = arg.soubor;

	// Setting up the input file
	ifstream file(filePath, ios::binary);
	if (!file.is_open()) {
		cout << "Error opening input file" << endl;
	}

	// Local variables
	string str;
	string highStr;
	string highFilter;
	string filter(arg.filtr);
	highFilter = str_to_upper(filter);
	
	// Creating output file handle
	ofstream outputFile;

	// Reading the file
	do {
		// read byte
		// decode byte value
		// use that value to read next number of bytes
		// use those bytes to know the name
		highStr = str_to_upper(str);

		if (same_prefix(highStr, highFilter)) {
			EnterCriticalSection(&readLock);
			resultCount++;
			LeaveCriticalSection(&readLock);
			
			EnterCriticalSection(&writeLock);
			outputFile.open("JmenaX.txt");
			outputFile << highStr << endl;
			outputFile.close();
			LeaveCriticalSection(&writeLock);
		}
		highStr = "";
	} while (file.peek() != EOF);
	// Exiting thread with result
	ExitThread(resultCount);
}


int main(int argc, char** argv) {
	// Thread handles
	HANDLE thdrs[2];

	// Initialize critical sections
	InitializeCriticalSection(&readLock);
	InitializeCriticalSection(&writeLock);

	// Input prefix from keyboard
	cout << "Zadejte prefix: ";
	char filter[50];
	cin >> filter;

	/* Creating structure, cuz 3rd arg of CreateThread is one address
	and we need to pass two args to function */
	tParam t = { "JmenaB", filter };

	// Creates and checks if threads were assigned successfully
	thdrs[0] = CreateThread(NULL, 0, &hledat, &t, CREATE_SUSPENDED, NULL);
	if (NULL == thdrs[0]) {
		cout << "Thread creation failed";
	}
	thdrs[1] = CreateThread(NULL, 0, &hledat, &t, CREATE_SUSPENDED, NULL);
	if (NULL == thdrs[1]) {
		cout << "Thread creation failed";
	}

	// Waits for thread creation
	WaitForMultipleObjects(2, thdrs, TRUE, INFINITE);

	assert(thdrs[0] && thdrs[1]);

	// Starts the threads
	ResumeThread(thdrs[0]);
	ResumeThread(thdrs[1]);

	// Returning exit codes of each thread
	DWORD resultThread1;
	GetExitCodeThread(thdrs[0], &resultThread1);
	DWORD resultThread2;
	GetExitCodeThread(thdrs[1], &resultThread2);

	// Outputting the results
	cout << "Thread-1 result: " << resultThread1 << endl;
	cout << "Thread-2 result: " << resultThread2;

	// Closing critical section
	DeleteCriticalSection(&readLock);
	DeleteCriticalSection(&writeLock);

	// Closing thread handles
	CloseHandle(thdrs[0]);
	CloseHandle(thdrs[1]);

	// Closing main process
	ExitProcess(0);
}
