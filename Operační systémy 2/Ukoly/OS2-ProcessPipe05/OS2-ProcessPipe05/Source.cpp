#include <Windows.h>
#include <stdio.h>
#include <iostream>		
#include <cmath>
#include <string>

using namespace std;

#define BUFFSIZE 512

char* GetAnswerToRequest(LPTSTR chRequest, LPTSTR chReply);


int main()
{
	BOOL fConnected;
	HANDLE hPipe;
	//LPTSTR lpszPipename = TEXT("\\\\.\\pipe\\Pipe1");


	while (true)
	{
		hPipe = CreateNamedPipe(
			(LPTSTR)"\\\\.\\pipe\\Pipe1",
			PIPE_ACCESS_DUPLEX,
			PIPE_TYPE_MESSAGE |
			PIPE_READMODE_MESSAGE |
			PIPE_WAIT,
			1,
			BUFFSIZE,
			BUFFSIZE,
			0,
			NULL);


		fConnected = ConnectNamedPipe(hPipe, NULL) ?
			TRUE :
			(GetLastError() == ERROR_PIPE_CONNECTED);

		// Receive message from client
		CHAR chRequest[BUFFSIZE];
		CHAR chReply[BUFFSIZE];
		DWORD cbBytesRead, cbWritten;
		BOOL fSuccess;

		while (1)
		{
			// Read client requests from the pipe. 
			fSuccess = ReadFile(
				hPipe,        // handle to pipe 
				chRequest,    // buffer to receive data 
				BUFFSIZE,      // size of buffer 
				&cbBytesRead, // number of bytes read 
				NULL);        // not overlapped I/O 
			if (!fSuccess || cbBytesRead == 0)
				break;
			char* answer = GetAnswerToRequest((LPTSTR)chRequest, (LPTSTR)chReply);

			// Write the reply to the pipe. 
			fSuccess = WriteFile(
				hPipe,        // handle to pipe 
				answer,      // buffer to write from 
				strlen(answer), // number of bytes to write 
				&cbWritten,   // number of bytes written 
				NULL);        // not overlapped I/O 
		}

		// Flush the pipe to allow the client to read the pipe's contents 
		// before disconnecting. Then disconnect the pipe, and close the 
		// handle to this pipe instance. 

		FlushFileBuffers(hPipe);
		DisconnectNamedPipe(hPipe);
		CloseHandle(hPipe);
	}


	cout << "Quiting server" << endl;
	return 0;
}

char* preved(unsigned int z1, unsigned int z2, char* cislo)
{
	int k = 0;
	for (int j = 0, i = strlen(cislo) - 1; j < strlen(cislo); j++, i--)
	{
		if (cislo[j] >= '0' && cislo[j] <= '9' && (cislo[j] - 48) < z1)
			k += (cislo[j] - 48) * pow(z1, i);
		else if (cislo[j] >= 'A' && cislo[j] <= 'Z' && (cislo[j] - 55) < z1)
			k += (cislo[j] - 55) * pow(z1, i);
		else
		{
			printf("Je spatne uvedene cislo. Uved'te prosim spravne... \n");
			return NULL;
		}
	}
	char* tmp = (char*)malloc(sizeof(char));
	itoa(k, tmp, z2);
	for (int j = 0; j < strlen(tmp); j++)
	{

		if ((tmp[j] >= 97) && (tmp[j] <= 122))
		{

			tmp[j] = tmp[j] - 32;
		}
	}
	return tmp;
}

char* GetAnswerToRequest(LPTSTR chRequest, LPTSTR chReply)
{
	string cislo = "";
	string zaklad = "";
	int i = 0;
	for (i = 0; i < strlen((char*)chRequest); i++)
	{
		cout << chRequest[i] << endl;
		if (chRequest[i] == ' ')
			break;
		cislo += chRequest[i];
	}
	i++;
	for (; i < strlen((char*)chRequest); i++)
	{

		zaklad += chRequest[i];
	}

	cout << cislo << "-" << zaklad << endl;
	cout << zaklad << endl;
	char* c = new char[cislo.length() + 1];
	strcpy(c, cislo.c_str());
	char* z = new char[zaklad.length() + 1];
	strcpy(z, zaklad.c_str());
	return preved(10, atoi(z), c);
}