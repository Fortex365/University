#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

void printFloat(float cislo, unsigned int presnost) {	//Vstup cislo 1,23456 s p�esnost� 2
	int i = 0, j = 0;
	float new_float = 0;

	for (i = 0; i < presnost; i++) { //��slo 1,23456 p�evede na 123,456
		cislo = cislo * 10;	
	}

	int help_number;
	help_number = cislo;	//Z ��sla 123,456 se stane ��slo 123
	new_float = help_number;	//P�esunut� cel�ho ��sla 123 do prom�nn�, kter� je typu float

	for (j = 0; j < presnost; j++) { //��slo 123 vr�t�me na 1,23
		new_float = new_float / 10;	
	}
	printf("Cislo %f se zadanou presnosti %i je nyni: %f \n\n", cislo, presnost, new_float);	//Vyp�eme ��slo 1,23
}

int main() {
	float number = 0;
	unsigned int accuracy = 0;

	printf("Zadejte prosim desetinne cislo: ");
	scanf("%f", &number);
	printf("Zadejte prosim presnost na kterou chcete dane desetinne cislo: ");
	scanf("%i", &accuracy);

	printFloat(number, accuracy);

	return 0;
}