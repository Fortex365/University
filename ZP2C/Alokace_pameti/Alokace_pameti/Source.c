#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int* data;
	int velikost;
	int hlava;
} pizza;

void init(int);
void uvolni();
void pridej(int);
void vypis(int* pole, int velikost) {
	for (int i = 0; i < velikost; i++) {
		printf("%d|", pole[i]);
	}
}
void odeberposledni(int* pole, int velikost) {
	pole[velikost - 1] = -1;
}

void hledani(int hledanecislo, int* pole, int velikost) {
	for (int i = 0; i < velikost; i++) {
		if (pole[i] == hledanecislo) {
			return 1; 
		}
	}
	return -1;
}

void odebertohle(int odstranovanecislo, int* pole, int velikost) {
	for (int i = 0; i < velikost; i++) {
		if (pole[i] == odstranovanecislo) {
			pole[i] = -1;
		}
	}
	
	int aktualnivelikost = velikost;
	for (int j = velikost; j != 0; j--) {
		if (pole[j] == -1) {
			aktualnivelikost--;
		}
	}
	free(pole);
	int* pole = malloc(sizeof(int) * aktualnivelikost);
}

int main() {
	int i = 7;
	init(4);
	pridej(i);
	pizza mojedata;
	vypis(mojedata.data, mojedata.velikost);
	uvolni();

	return 0;
}