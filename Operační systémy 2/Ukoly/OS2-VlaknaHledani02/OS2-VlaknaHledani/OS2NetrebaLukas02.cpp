#include <windows.h>
#include <string>
#include <iostream>
#include <assert.h>
#include <fstream>
using namespace std;

struct tParam
{
	const char* soubor, *filtr;
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
	unsigned int resultCount = 0;
	
	// Unpacking the arguments from the address
	tParam arg = *((tParam*)prefix);
	string filePath = arg.soubor;

	// Setting up the input file
	ifstream file(filePath);
	if (!file.is_open()) {
		cout << "Error opening input file" << endl;
	}

	// Local variables
	string str;
	string highStr;
	string highFilter;
	string filter(arg.filtr);
	highFilter = str_to_upper(filter);

	// Reading lines in file
	while (getline(file, str)) {
		highStr = str_to_upper(str);
		
		if(same_prefix(highStr, highFilter)){
			resultCount++;
		}
		highStr = "";
	}

	// Exiting thread with result
	ExitThread(resultCount);
}


int main(int argc, char** argv) {
	// Thread handles
	HANDLE thdrs[2];

	// Input prefix from keyboard
	cout << "Zadejte prefix: ";
	char filter[50];
	cin >> filter;

	/* Creating structure, cuz 3rd arg of CreateThread is one address 
	and we need to pass two args to function */ 	
	tParam t1 = { "Jmena1", filter};
	tParam t2 = { "Jmena2", filter};

	// Creates and checks if threads were assigned successfully
	thdrs[0] = CreateThread(NULL, 0, &hledat, &t1 , 0, NULL);
	if (NULL == thdrs[0]) {
		cout << "Thread creation failed";
	}
	thdrs[1] = CreateThread(NULL, 0, &hledat, &t2, 0, NULL);
	if (NULL == thdrs[1]) {
		cout << "Thread creation failed";
	}

	// Waits for thread creation
	WaitForMultipleObjects(2, thdrs, TRUE, INFINITE);

	assert(thdrs[0] && thdrs[1]);

	// Returning exit codes of each thread
	DWORD resultThread1;
	GetExitCodeThread(thdrs[0], &resultThread1);
	DWORD resultThread2;
	GetExitCodeThread(thdrs[1], &resultThread2);

	// Outputting the results
	cout << "Thread-1 result: " << resultThread1 << endl;
	cout << "Thread-2 result: " << resultThread2;

	// Closing thread handles
	CloseHandle(thdrs[0]);
	CloseHandle(thdrs[1]);

	// Closing main process
	ExitProcess(0);
}
