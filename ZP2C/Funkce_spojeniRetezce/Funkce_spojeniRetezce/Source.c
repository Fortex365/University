#include <stdio.h>
#include <string.h>

//Naprogramujte funkci pro spojen� dvou textov�ch �et�zc�. Argumentem funkce jsou dva textov� �et�zce ke spojen�, funkce vr�t� nov� �et�zec (jako ukazatel).

#define size 100

char *MergeCharArray(char *first[], char *second[]) {
	char *merged = malloc(sizeof(char) * (strlen(first) + strlen(second)));

	memcpy(merged, first, sizeof(char)*strlen(first));	//Zkop�rov�n� �et�zce 'first' do v�t��ho �et�zce 'merged'
	memcpy(merged + strlen(first), second, sizeof(char)*strlen(second));	//Za �et�zec 'first' zkop�rujeme �et�zec 'second'

	return merged;	//Vr�cen� ukazatele pole vracen�ho pole
}

int main() {
	char pole1[] = "aaa";
	char pole2[] = "abc";
	printf("%s", MergeCharArray(pole1, pole2));
	return 0;
}
