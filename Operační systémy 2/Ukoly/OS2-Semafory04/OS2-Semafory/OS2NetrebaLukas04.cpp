#include <Windows.h>
#include <iostream>
#include <fstream>
using namespace std;

// Global variable inicializations
HANDLE SPACE;
HANDLE ITEM;

ifstream READ;
ofstream WRITE;

// Analogy with handing a baton
int batonNumber;


DWORD Produce()
{
	// Variable inicializations
	char byte, first, second;
	const int READBYTE = 1;
	int number = 0;
	DWORD blacklistCnt = 0;

	while (true)
	{
		READ.read(&byte, READBYTE);
		first = (byte & 0xF0) >> 4;
		second = byte & 0xF;

		if (!READ.good() ||
			READ.eof())
		{
			break;
		}

		number *= 10;
		number += first;

		if (second > 9)
		{
			if (second == 0xB ||
				second == 0xD)
			{
				number *= -1;
			}
			blacklistCnt++;

			// Acquiring space to trade with Consume
			WaitForSingleObject(SPACE, INFINITE);
			batonNumber = number;

			// Releasing item during trade with Consume
			ReleaseSemaphore(ITEM, 1, NULL);
			number = 0;
		}
		else 
		{
			number *= 10;
			number += second;
		}
	}

	// Acquiring space to trade with Consume
	WaitForSingleObject(SPACE, INFINITE);
	batonNumber = INT_MIN;

	// Releasing item during trade with Consume
	ReleaseSemaphore(ITEM, 1, NULL);

	return blacklistCnt;
}


DWORD Consume()
{
	// Variable inicializations
	DWORD writenCnt = 0;
	int number;

	// Acquiring item from trade with Produce
	WaitForSingleObject(ITEM, INFINITE);

	while (batonNumber != INT_MIN)
	{
		number = batonNumber;

		// Releasing space during trade with Produce
		ReleaseSemaphore(SPACE, 1, NULL);
		WRITE << number;

		if (++writenCnt % 10 == 0)
		{
			WRITE << endl;
		}
		else {
			WRITE << ' ';
		}

		// Acquiring item from trade with Produce
		WaitForSingleObject(ITEM, INFINITE);
	}

	return writenCnt;
}


int main(int argc, char** argv)
{
	// Inicialization of semaphores for CS (Critical Section)
	SPACE = CreateSemaphore(NULL, 1, 1, NULL);
	ITEM = CreateSemaphore(NULL, 0, 1, NULL);

	// Opening the working files
	READ.open("Prvocisla.bcd", ios::binary);
	WRITE.open("Prvocisla.txt", ios::out);

	// Checking proper file opening
	if (!READ.is_open() ||
		!WRITE.is_open())
	{
		cout << "Nepodarilo se otevrit soubor!" << endl;
		return -1;
	}

	// Thread handles
	HANDLE thrds[2];

	// Creates and checks if threads were assigned successfully
	thrds[0] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)Produce, NULL, 0, NULL);

	if (NULL == thrds[0])
	{
		cout << "Thread creation failed" << endl;
		return -1;
	}

	thrds[1] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)Consume, NULL, 0, NULL); 

	if (NULL == thrds[1])
	{
		cout << "Thread creation failed" << endl;
		return -1;
	}

	if (WaitForMultipleObjects(2, thrds, true, INFINITE) == WAIT_FAILED)
	{
		cout << "Nepodarilo se radne vytvorit vlakna!" << endl;
		return -1;
	}

	// Outputting the results
	DWORD returned;
	GetExitCodeThread(thrds[0], &returned);
	cout << "Thread-1 " << " Prectenych: " << returned << endl;

	GetExitCodeThread(thrds[1], &returned);
	cout << "Thread-2 " << " Zapsanych: " << returned << endl;

	// Closing thread handles
	CloseHandle(thrds[0]);
	CloseHandle(thrds[1]);

	// Closing critical section
	CloseHandle(SPACE);
	CloseHandle(ITEM);

	// Closing files
	READ.close();
	WRITE.close();

	// Exit main
	ExitProcess(0);
}