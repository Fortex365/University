#include <stdio.h>
#include <string.h>

//Naprogramujte funkci, která bere jako argument 2 promìnné a provede výmìnu hodnot tìchto dvou promìnných.

void My_swap(int *a, int *b) {	//Pøedávaná adresa bude pro nás jako pointer
	int store;
	store = *a;	//Do pomocné promìnné pomocí *a (dereference) uložíme hodnotu Á-èka
	*a = *b;	//Na místo kam ukazuje a, uložíme hodnotu uloženou v b
	*b = store;	//Na místo kam ukazuje b, uložíme hodnotu z pomocné promìnné
}

int main() {
	int first = 10;
	int second = 20;

	printf("%d, %d\n", first, second);
	My_swap(&first, &second);	//Pøedáváme adresu
	printf("%d, %d\n", first, second);

	return 0;
}