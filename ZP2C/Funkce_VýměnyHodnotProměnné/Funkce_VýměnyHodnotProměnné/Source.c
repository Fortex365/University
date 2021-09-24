#include <stdio.h>
#include <string.h>

//Naprogramujte funkci, kter� bere jako argument 2 prom�nn� a provede v�m�nu hodnot t�chto dvou prom�nn�ch.

void My_swap(int *a, int *b) {	//P�ed�van� adresa bude pro n�s jako pointer
	int store;
	store = *a;	//Do pomocn� prom�nn� pomoc� *a (dereference) ulo��me hodnotu �-�ka
	*a = *b;	//Na m�sto kam ukazuje a, ulo��me hodnotu ulo�enou v b
	*b = store;	//Na m�sto kam ukazuje b, ulo��me hodnotu z pomocn� prom�nn�
}

int main() {
	int first = 10;
	int second = 20;

	printf("%d, %d\n", first, second);
	My_swap(&first, &second);	//P�ed�v�me adresu
	printf("%d, %d\n", first, second);

	return 0;
}