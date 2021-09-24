#define _CRT_SECURE_NO_WARNINGS	//Pokud bude definovany pod knihovnou, stejnì pro scanf bude vyhazovat error

#include <stdio.h>	//funkce printf, scanf
#include <stdlib.h>
#include <string.h>	//funkce strlen

#define size 32

int main() {
	char retezec[size];	//Øetìzec se kterým budem pracovat
	char compare[1];	//Jeden znak z øetìzce, který budeme porovnávat jestli se nachází v øetìzci víckrát
	int count = 0, i, j, k = 0, size_of_input = 0;

	printf("Zadejte, prosim, vstupni retezec: ");
	scanf("%31s", retezec);	//Vstup øetìzce od uživatele

	while (retezec[k] != '\0') {
		size_of_input++;
		k++;
	}

	for (i = 0; i < size_of_input; i++) {	//Projdeme celý øetìzec
		compare[0] = retezec[i];	//Do compare si dáme první znak z øetìzce
		for (j = 0; j < size_of_input; j++) {	//Poèítáme kolikrát je výskyt 'compare' v øetìzci
			if (compare[0] == retezec[j]) { //Pokud je nalezen zvýšíme counter
				count++;
			}
			continue;	//Pokud není nalezen, hledáme v dalších iteracích
		}
		printf("Character %c found: ", compare[0]);	//Vypíšeme, jaký znak jsme poèítali jeho výskyt
		printf("%d\n", count);	//a kolikrát se vyskytuje v øetìzci
	}

	printf("\n");
	return (EXIT_SUCCESS);
}