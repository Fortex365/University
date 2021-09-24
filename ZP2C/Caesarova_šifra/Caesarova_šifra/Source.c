#define _CRT_NO_SECURE_WARNINGS
#define size 64

#include <stdio.h>
#include <string.h>


void decode(char *vstup[], int posuv) {
	int i = 0;
	int delka = strlen(vstup);
	char vystup[size];

	for (i = 0; i < delka; i++) {	//Všechna písmenka ve vstupním poli posuneme zpátky, vèetnì pøenosu písmena a/A na písmeno z/Z
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
	int pokusy = 26, i; //Celkem je 26 písmen v abecedì, bez diakritiky

	for (i = pokusy; pokusy != 0; i--) {	//Hrubou sílou vypíšeme všechny možnosti vstupu s klíèem v intervalu celých èísel (0, 26>
		printf("Klic %d:\n", pokusy);
		decode(vstup, pokusy);
		pokusy--;
	}
	return 0;
}
