#include <stdio.h>

int main() {
	char polec[2];
	int polei[2];
	double poled[2];

	//D�lka charu sizeof(char)
	int adresa_d = &polec[0];   //adresa_down
	int adresa_u = &polec[2];   //adresa_upper

	printf("%i\n", adresa_u - adresa_d);

	//D�lka intu sizeof(int)
	adresa_d = &polei[0];
	adresa_u = &polei[2];

	printf("%i\n", adresa_u - adresa_d);

	//D�lka double sizeof(double)
	adresa_d = &poled[0];
	adresa_u = &poled[2];

	printf("%i\n", adresa_u - adresa_d);

	return 0;
}