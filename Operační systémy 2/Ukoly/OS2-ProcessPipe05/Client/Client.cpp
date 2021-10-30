#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <Windows.h>
#include <stdio.h>
#include <iostream>		
#include <string>
#include <cassert>
using namespace std;

#define BUFFER_SIZE 256
#define REQUEST_REPLY_BYTES 64
#define INT_BYTES 4


HANDLE ConnectPipe()
{
    HANDLE pipe = CreateFile(
        L"\\\\.\\pipe\\PIPE01",
        GENERIC_READ | GENERIC_WRITE,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    return pipe;
}


int RequestReply(HANDLE pipe)
{
    int requestingNumber, requestingBase;
    char* reply = new char[REQUEST_REPLY_BYTES];
    DWORD sendBytes;

    while (true)
    {
        cout << "Enter number: ";
        cin >> requestingNumber;
        WriteFile(pipe, &requestingNumber, INT_BYTES, &sendBytes, NULL);

        if (requestingNumber == 0)
        {
            break;
        }

        cout << "Enter base: ";
        cin >> requestingBase;
        
        while (requestingBase > 36 || requestingBase < 2)
        {
            cout << "Try again entering base: ";
            cin >> requestingBase;
        }

        WriteFile(pipe, &requestingBase, INT_BYTES, &sendBytes, NULL);

        if (!ReadFile(pipe, reply, REQUEST_REPLY_BYTES, NULL, NULL))
        {
            assert(CloseHandle(pipe));
            return 1;
        }
        cout << requestingNumber << " (" << requestingBase << ") = " << reply << endl;
    }

    return 0;
}


int main(int argc, char** argv)
{
    // Connect
    HANDLE pipe = ConnectPipe();
    assert(pipe != INVALID_HANDLE_VALUE);

    // Communication
    int returned = RequestReply(pipe);

    // Close
    CloseHandle(pipe);

    return returned;
}