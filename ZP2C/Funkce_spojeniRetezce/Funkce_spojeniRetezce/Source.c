#include <stdio.h>
#include <string.h>

//Naprogramujte funkci pro spojení dvou textových øetìzcù. Argumentem funkce jsou dva textové øetìzce ke spojení, funkce vrátí nový øetìzec (jako ukazatel).

#define size 100

char *MergeCharArray(char *first[], char *second[]) {
	char *merged = malloc(sizeof(char) * (strlen(first) + strlen(second)));

	memcpy(merged, first, sizeof(char)*strlen(first));	//Zkopírování øetìzce 'first' do vìtšího øetìzce 'merged'
	memcpy(merged + strlen(first), second, sizeof(char)*strlen(second));	//Za øetìzec 'first' zkopírujeme øetìzec 'second'

	return merged;	//Vrácení ukazatele pole vraceného pole
}

int main() {
	char pole1[] = "aaa";
	char pole2[] = "abc";
	printf("%s", MergeCharArray(pole1, pole2));
	return 0;
}
