#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define velikost 10

int porovnej(char* jedna[], char* dva[]) {
	while ((*jedna != '\0' && *dva != '\0') && *jedna == *dva) {
		jedna++;
		dva++;
	}
	if (*jedna == *dva) {
		return 0;
	}
	else {
		if ((*jedna - *dva) > 0) {
			return 1;
		}
		return -1;
	}
}

int main() {
	char pole1[] = "Ahoj";
	char pole2[] = "Penis";

	porovnej(pole1, pole2);
	return 0;
}