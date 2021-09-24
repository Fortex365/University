#define _CRT_SECURE_NO_WARNINGS	//Pokud bude definovany pod knihovnou, stejn� pro scanf bude vyhazovat error

#include <stdio.h>	//funkce printf, scanf
#include <stdlib.h>
#include <string.h>	//funkce strlen

#define size 32

int main() {
	char retezec[size];	//�et�zec se kter�m budem pracovat
	char compare[1];	//Jeden znak z �et�zce, kter� budeme porovn�vat jestli se nach�z� v �et�zci v�ckr�t
	int count = 0, i, j, k = 0, size_of_input = 0;

	printf("Zadejte, prosim, vstupni retezec: ");
	scanf("%31s", retezec);	//Vstup �et�zce od u�ivatele

	while (retezec[k] != '\0') {
		size_of_input++;
		k++;
	}

	for (i = 0; i < size_of_input; i++) {	//Projdeme cel� �et�zec
		compare[0] = retezec[i];	//Do compare si d�me prvn� znak z �et�zce
		for (j = 0; j < size_of_input; j++) {	//Po��t�me kolikr�t je v�skyt 'compare' v �et�zci
			if (compare[0] == retezec[j]) { //Pokud je nalezen zv���me counter
				count++;
			}
			continue;	//Pokud nen� nalezen, hled�me v dal��ch iterac�ch
		}
		printf("Character %c found: ", compare[0]);	//Vyp�eme, jak� znak jsme po��tali jeho v�skyt
		printf("%d\n", count);	//a kolikr�t se vyskytuje v �et�zci
	}

	printf("\n");
	return (EXIT_SUCCESS);
}