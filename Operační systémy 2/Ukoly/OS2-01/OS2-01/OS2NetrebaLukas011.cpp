#include <Windows.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

int main(int argc, char** argv) {
	int a = atoi(argv[0]);
	char symbol = argv[1][0];

	for (int i = 0; i < a; i++)
	{
		for (int j = 0; j < a; j++)
		{
			printf("%c", symbol);

		}
		printf("\n");
	}
	Sleep(2000);
	return 0;
}