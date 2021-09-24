#define _CRT_NO_SECURE_WARNINGS
#define size 32
#include <stdio.h>

void Fill_array(int my_array[]) { //Naplni pole v intervalem <1, size>
	int i;

	printf("|");
	for (i = 1; i < size; i++) {
		my_array[i] = i;
		printf("%d|", my_array[i]);
	}
	printf("\n");
}

void Print_array(int my_array[], int start, int step, int end) { //Vypisuje pole dle zadaných požadavkù, tedy zaèátek a konec, popø. krok
	int i;

	printf("Printed array with parametrs start: %d, step: %d, end: %d\n", start, step, end);
	printf("|");
	for (i = start; i < end; i += step) {
		printf("%d|", my_array[i]);
	}
}

int main() {
	int my_array[size];
	Fill_array(my_array);
	Print_array(my_array, 5, 3, 10);
	return 0;
}