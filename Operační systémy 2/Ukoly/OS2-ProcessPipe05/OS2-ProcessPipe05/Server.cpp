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


HANDLE CreatePipe() 
{
    HANDLE pipe = CreateNamedPipe(
        L"\\\\.\\pipe\\PIPE01",
        PIPE_ACCESS_DUPLEX,
        PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
        1,
        BUFFER_SIZE,
        BUFFER_SIZE,
        0,
        NULL);

    return pipe;
}


int Communication(HANDLE pipe)
{
    int requestedNumber, requestedBase;
    char* number = new char[REQUEST_REPLY_BYTES];
    DWORD sentBytes;

    while (true)
    {
        if (!ReadFile(pipe, &requestedNumber, INT_BYTES, NULL, NULL))
        {
            assert(DisconnectNamedPipe(pipe));
            return 1;
        }

        if (requestedNumber == 0)
        {
            break;
        }

        if (!ReadFile(pipe, &requestedBase, INT_BYTES, NULL, NULL))
        {
            assert(DisconnectNamedPipe(pipe));
            return 1;
        }
        _itoa(requestedNumber, number, requestedBase);
        cout << number;
        WriteFile(pipe, number, REQUEST_REPLY_BYTES, &sentBytes, NULL);
    }
    
    return 0;
}


int main(int argc, char** argv)
{
    // Creation
    HANDLE pipe = CreatePipe();
    assert(pipe != INVALID_HANDLE_VALUE);

    // Client connection
    assert(ConnectNamedPipe(pipe, NULL));

    // Comm
    int returned = Communication(pipe);

    // Disconnect
    assert(DisconnectNamedPipe(pipe));
    CloseHandle(pipe);
    return returned;
}