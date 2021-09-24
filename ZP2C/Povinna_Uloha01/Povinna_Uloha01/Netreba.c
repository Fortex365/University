#include <stdio.h>
#include <stdarg.h>
#include <string.h>

void my_print(char string[], ...) {
	va_list parameters;
	va_start(parameters, string);

	int string_length = strlen(string);
	int optional_p = 0;
	double optional_pfloat = 0;
	char optional_pchar = '0';

	for (int i = 0; i < string_length; i++) {
		if ((string[i] == '*') && (string[i + 1] == 'i')) {
			optional_p = va_arg(parameters, int);
			printf("%i", optional_p);
			i++;
			continue;
		}
		if ((string[i] == '*') && (string[i + 1] == 'c')) {
			optional_pchar = (char)va_arg(parameters, int);
			printf("%c", optional_pchar);
			i++;
			continue;
		}
		if ((string[i] == '*') && (string[i + 1] == 'f')) {
			optional_pfloat = va_arg(parameters, double);
			printf("%f", optional_pfloat);
			i++;
			continue;
		}
		//TENHLE IF JE TU ZBYTE�N�, PROTO�E POU��V�M CONTINUE V KA�D�M BLOKU IF, TAK�E KDY� U� SE SEM K�D DOSTANE
		//TAK JE TO JASN�, �E NEBYLO U� JINAK NA V�B�R A TUD͎ JE ZBYTE�N� Z HLEDISKA �ASOV� N�RO�NOSTI PO��TAT DAL�� IF(Y)
		if (((string[i] != '*') && ((string[i + 1] != 'i') || (string[i + 1] != 'c') || (string[i + 1] != 'f'))) || 
			((string[i] != 'i') || (string[i] != 'c') || (string[i] != 'f')) && (string[i - 1] != '*')) {
			printf("%c", string[i]);
			continue;
		}
	}
	va_end(parameters);
}

int main() {
	int cislo = 10;
	char pismenko = 'g';
	double desetinny = 3.14;

	my_print("Text *i *c *f text2 *c", cislo, pismenko, desetinny, pismenko);

	return 1; //PROGRAM SUCCESED
}