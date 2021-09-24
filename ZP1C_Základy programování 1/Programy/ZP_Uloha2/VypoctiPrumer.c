#include <stdio.h>

int StringNaInt(char a[])		//PREVOD RETEZCE NA CISLO
{
	int znamenko = a[0] == '-' ? -1 : 0;
	unsigned int posun = znamenko == -1 ? 1 : 0;
	int hodnota = 0;

	for (int i = posun; a[i] != '\0'; i++)
	{
		hodnota = hodnota * 10 + a[i] - '0';
	}

	return znamenko == -1 ? -hodnota : hodnota;
}

void RetezecKopieCast(char vstup[], int pocatek, char vystup[], char zarazka)
{
	unsigned int i = 0;
	while ((vstup[pocatek + i] != zarazka) && (vstup[pocatek + i] != '\0'))
	{
		vystup[i] = vstup[pocatek + i];
		i++;
	}
	vystup[i] = '\0';
}

unsigned int VelikostRetezce(char a[])		//ZJISTENI VELIKOST RETEZCE
{
	unsigned int i = 0;
	while (a[i] != '\0')
	{
		i++;
	}
	return i;
}

unsigned int JeStringPlatny(char b[]) {
	int i;
	if (!((b[0] == '-') || ((b[0] >= '0') && (b[0] <= '9'))))
	{
		printf("String je neplatny!\n");
		return 0;
	}
	for (i = 1; b[i] != '\0'; i++)
	{
		if (!((b[i] >= '0') && (b[i] <= '9')))
		{
			printf("String je neplatny!\n");
			return 0;
		}
	}
	return 1;
}

double SpoctiPrumer(char retezec[])
{
	int hodnota = 0, velikost = VelikostRetezce(retezec), i = 0, platna_cisla = 0;

	if (velikost == 0)  //PRAZDNY RETEZEC
	{
		return 0;
	}

	char pomocne_pole[velikost];
	while (i < velikost)
	{
		RetezecKopieCast(retezec, i, pomocne_pole, ' ');

		if (!JeStringPlatny(pomocne_pole))
		{
			return 0;
		}

		hodnota = hodnota + StringNaInt(pomocne_pole);
		i = i + VelikostRetezce(pomocne_pole) + 1;
		platna_cisla++;
	}
	return (double)hodnota / (double)platna_cisla;
}

int main()
{
	printf("Prumer je: %f\n", SpoctiPrumer("0 11 222 3333 44444 555555 6666666"));					//VSTUP UZIVATELE, JEDNOTLIVA CISLA ODDELTE MEZEROU, VYJIMKOU JE ZNAK MINUS PRED CISLEM
	printf("Program vytvoren uzivatelem Lukas Netreba");
	return 0;
}
