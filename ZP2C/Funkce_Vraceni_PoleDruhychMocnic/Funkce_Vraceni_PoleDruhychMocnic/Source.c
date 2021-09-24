#include <stdio.h>
#include <string.h>

//Naprogramujte funkci, která jako argument bere pole èísel a vrátí pole jejich druhých mocnin (tedy prvek na indexu i vráceného pole bude mít hodnotu druhé mocniny prvku na indexu i vstupního pole

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
	ArrayExpt2(my_array);	//Jelikož je pole pointer, tak není do argumentu funkce nutné psát &my_array

	int my_size = strlen(my_array);
	int my_array2[my_size];
	my_array2 = ArrayExpt2(my_array);

	for (int i = 0; i < my_size; i++) {
		printf("%d|", my_array2[i]);
	}
	return 0;
}