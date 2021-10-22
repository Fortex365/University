#include <Windows.h>
#include <iostream>		
#include <string>
#include <cmath>
#include <stdio.h>

using namespace std;

int main()
{
	HANDLE hPipe;
	LPVOID lpvMessage;
	CHAR chBuf[512];
	BOOL fSuccess;
	DWORD cbRead, cbWritten, dwMode;
	//LPTSTR lpszPipename = TEXT("\\\\.\\pipe\\Pipe1");


	hPipe = CreateFile(
		(LPTSTR)"\\\\.\\pipe\\Pipe1",   // pipe name 
		GENERIC_READ |  // read and write access 
		GENERIC_WRITE,
		0,              // no sharing 
		NULL,           // no security attributes
		OPEN_EXISTING,  // opens existing pipe 
		0,              // default attributes 
		NULL);          // no template file 

	// The pipe connected; change to message-read mode. 

	dwMode = PIPE_READMODE_MESSAGE;
	fSuccess = SetNamedPipeHandleState(
		hPipe,    // pipe handle 
		&dwMode,  // new pipe mode 
		NULL,     // don't set maximum bytes 
		NULL);    // don't set maximum time 

	// Send a message to the pipe server. 

	cin >> lpvMessage;

	fSuccess = WriteFile(
		hPipe,                  // pipe handle 
		lpvMessage,             // message 
		strlen((const char*)lpvMessage) + 1, // message length 
		&cbWritten,             // bytes written 
		NULL);                  // not overlapped 
		// Read from the pipe. 

	fSuccess = ReadFile(
		hPipe,    // pipe handle 
		chBuf,    // buffer to receive reply 
		512,      // size of buffer 
		&cbRead,  // number of bytes read 
		NULL);    // not overlapped 

	for (size_t i = 0; i < cbRead; i++)
	{
		cout << chBuf[i];
	}
	cout << endl;

	CloseHandle(hPipe);

	getchar();
	return 0;
}
