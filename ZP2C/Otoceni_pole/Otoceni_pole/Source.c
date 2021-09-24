#define _CRT_NO_SECURE_WARNINGS
#define size 32
#include <stdio.h>

void Fill_array(int my_array[]){
	int i;

	printf("|");
	for (i = 1; i < size; i++) {
		my_array[i] = i;
		printf("%d|", my_array[i]);
	}
	printf("\n");
}

void Reverse_array(int my_array[]) {
	int n_pole[size];
	int j = 0, e;

	printf("|");
	for (e = size - 1; e != 0; e--) {
		n_pole[j] = my_array[e];
		printf("%d|", n_pole[j]);
	}
	printf("\n");
}

void Reverse_array_p(int *p) {
	int i, Store_value;
	for (i = 0; i < size/2; i++) {
		Store_value = *(p + i);
		*(p + i) = *(p + size - 1 - i);
		*(p + size - 1 - i) = Store_value;
	}
}

void Print_array(int my_array[], int start, int step, int end) {
	int i;

	printf("|");
	for (i = start; i < end; i += step) {
		printf("%d|", my_array[i]);
	}
}

int main() {
	int my_array[size];
	Fill_array(my_array);
	Reverse_array(my_array);
	//Reverse_array_p(*my_array);
	//Print_array(my_array, 5, 3, 10);
	return 0;
}