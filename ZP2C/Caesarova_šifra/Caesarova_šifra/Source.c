#define _CRT_NO_SECURE_WARNINGS
#define size 64

#include <stdio.h>
#include <string.h>


void decode(char *vstup[], int posuv) {
	int i = 0;
	int delka = strlen(vstup);
	char vystup[size];

	for (i = 0; i < delka; i++) {	//V�echna p�smenka ve vstupn�m poli posuneme zp�tky, v�etn� p�enosu p�smena a/A na p�smeno z/Z
		if (vstup[i] = 'a' && posuv > 0) {
			vstup[i] = 'z';
			vystup[i] = vstup[i] - posuv - 1;
		}
		if (vstup[i] = 'A' && posuv > 0) {
			vstup[i] = 'Z';
			vystup[i] = vstup[i] - posuv - 1;
		}
		vystup[i] = vstup[i] - posuv;
	}
	printf("%s\n\n", vystup);
}

int main() {
	char *vstup[] = "mrwfvqbfcryivfiqborxqlfrmnqanmirpvpbfvcerwrfarqnxbhcvgibopubqr";
	int pokusy = 26, i; //Celkem je 26 p�smen v abeced�, bez diakritiky

	for (i = pokusy; pokusy != 0; i--) {	//Hrubou s�lou vyp�eme v�echny mo�nosti vstupu s kl��em v intervalu cel�ch ��sel (0, 26>
		printf("Klic %d:\n", pokusy);
		decode(vstup, pokusy);
		pokusy--;
	}
	return 0;
}
