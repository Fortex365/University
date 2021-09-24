#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
//NAZEV MACRA BY MEL BYT VELKYMI PISMENY
#define size 256

int IsCapital(char c) {
	if (c >= 'A' && c <= 'Z') {
		return 1;
	}
	else {
		return 0;
	}
}

int IsSmall(char c) {
	if (c >= 'a' && c <= 'z') {
		return 1;
	}
	else {
		return 0;
	}
}

//JDE TO UDELAT OBECNE, ZE BUDEM UCHOVAVAT HODNOTU NEJDELSIHO RADKU V JEDNE PROMENNE, JA TO ZE ZAJIMAVOSTI
//UDELAL ABYCH UCHOVAVAL DELKU VSECH RADKU, AVSAK TO ME POTE LIMITUJE NA VELIKOST MACRA SIZE
void FindLongest(int* array, int length) {
	int max = 0;

	for (int i = 0; i < length; i++) {
		if (array[i] > max) {
			max = array[i];
		}
	}
	printf("\nNejdelsi radek s poctem znaku vcetne mezer: %i\n", max);
}

void ArrayInit(int* array, int length) {
	for (int i = 0; i < length; i++) {
		array[i] = 0;
	}
}

int main() {
	FILE* fr;
	char c;

	int max_length = 0;
	int i = 0;
	int length_array[size];

	//ZADNE POLE NEVYTVAREJ ANI NEINICIALIZUJ, NEBUDE TO POTREBA
	ArrayInit(length_array, size); //Vynulujem si cele pole hodnot

	if ((fr = fopen("pr10-dopis.txt", "r")) == NULL)
		printf("Soubor se nepodaøilo otevøít \n");

	while (feof(fr) == 0) {	//Dokud není konec souboru
		c = getc(fr);

		//TENHLE IF-ELSE BUDE TA SRANDA, KDE TI TO BUDE POCITAT DELKU RADKU A V PRIPADE ZE JE VETSI NEZ ULOZENA DELKA RADKU (ZE ZACATKU 0), TAK JI NAHRADIS
		if (c != '\n') {
			max_length++;
		}
		else {
			length_array[i] = max_length;
			if (i >= 256) {
				printf("Limit programu je pouze 256 radku, pripadne zmente macro size!");
				return 0;
			}
			i++;
			max_length = 0;
			printf("\n");
			continue;
		}


		if (IsCapital(c)) { //Pokud je velké zmenšíme jej a vytisknem
			c = c + 32;
			printf("%c", c);
			continue;
		}
		if (IsSmall(c)) { //Pokud je malé zvìtšíme jej a vytiskneme
			c = c - 32;
			printf("%c", c);
			continue;
		}
		printf("%c", c); //Ostatní symboly nepísmen vytiskneme stejnì
	}

	//TOHLE TAM TAKY NEBUDE POTOM POTREBA
	//Po konci cyklu jsme urèitì na konci souboru, uložíme si délku posledního øádku
	length_array[i] = max_length - 1;
	if (i >= 256) {
		printf("Limit programu je pouze 256 radku, pripadne zmente macro size!");
		return 0;
	}
	i++;
	max_length = 0;

	//Pošleme nasbíraná data do funkce, která vypíše nejvìtší hodnotu, tedy nejdelší øádek
	FindLongest(length_array, size);

	if ((fclose(fr)) == EOF)
		printf("Soubor se nepodaøilo zavøít \n");

	return 0;
}