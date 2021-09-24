#include <stdio.h>
#include <string.h>

//Naprogramujte funkci, kter� jako argument bere pole ��sel a vr�t� pole jejich druh�ch mocnin (tedy prvek na indexu i vr�cen�ho pole bude m�t hodnotu druh� mocniny prvku na indexu i vstupn�ho pole

#define size 100;

void *ArrayExpt2(int *input[]) {
	int i;
	int *output = malloc(sizeof(int) * strlen(input));

	for (i = 0; i < strlen(input); i++) {
		output[i] = input[i] * input[i];
	}

	return output;
}

int main() {
	int my_array[] = { 1, 2, 3, 4, 5 };
	ArrayExpt2(my_array);	//Jeliko� je pole pointer, tak nen� do argumentu funkce nutn� ps�t &my_array

	int my_size = strlen(my_array);
	int my_array2[my_size];
	my_array2 = ArrayExpt2(my_array);

	for (int i = 0; i < my_size; i++) {
		printf("%d|", my_array2[i]);
	}
	return 0;
}