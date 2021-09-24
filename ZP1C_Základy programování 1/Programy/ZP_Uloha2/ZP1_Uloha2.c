#include <stdio.h>

int StringNaInt(char []);
double SpoctiPrumer(char []);
unsigned int VelikostRetezce(char []);
void RetezecKopieCast(char [], int, char [], char);

int main()
{
    char retezec[] = "0 11 22 3333 444444 555555 66666666";
    printf("Prumer je: %f\n", SpoctiPrumer(retezec));
    return 0;
}

unsigned int VelikostRetezce(char a[])                                                                   //ZJISTENI VELIKOST RETEZCE
{
    unsigned int i = 0;
    while(a[i] != '\0')
    {
        i++;
    }
    return i;
}

double SpoctiPrumer(char retezec[])
{
    int hodnota = 0, velikost = VelikostRetezce(retezec), i = 0, platna_cisla = 0;

    if(velikost == 0)                                                                                   //KDYBY RETEZEC BYL PRAZDNY TAK VYSLEDEK PRUMER BUDE 0
    {
        return 0;
    }

    char pomocne_pole[velikost];
    while (i < velikost)
    {
        RetezecKopieCast(retezec, i, pomocne_pole, ' ');
        hodnota += StringNaInt(pomocne_pole);
        i += VelikostRetezce(pomocne_pole) + 1;
        platna_cisla++;
    }
    return hodnota/platna_cisla;
}

int StringNaInt(char a[])           //PREVOD RETEZCE NA CISLO
{
    int c, znamenko = 0, posun, hodnota;


    if (a[0] == '-')
    {
        znamenko = -1;
    }

    if (znamenko == -1)
    {
        posun = 1;
    }
    else
    {
        posun = 0;
    }


    hodnota = 0;
    for (c = posun; a[c] != '\0'; c++)
    {
        hodnota = hodnota * 10 + a[c] - '0';
    }

    if (znamenko == -1)
    {
        return -hodnota;
    }

    return hodnota;
}

void RetezecKopieCast(char vstup[], int pocatek, char vystup[], char znak)
{
    int i = 0;
    while ((vstup[pocatek + i] != znak) && (vstup[pocatek + i] != '\0'))
    {
        vystup[i] = vstup[pocatek + i];
        i++;
    }
}
