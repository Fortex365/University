#include <stdio.h>

int StringNaInt(char a[])                                                                              //PREVOD RETEZCE NA CISLO
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

unsigned int VelikostRetezce(char a[])                                                                //ZJISTENI VELIKOST RETEZCE
{
    unsigned int i = 0;
    while(a[i] != '\0')
    {
        i++;
    }
    return i;
}

int jeStringValidni(char a[]){
    int i;
    if((a[0] != '-') && ((a[0] < '0') || (a[0] > '9')))
    {
        return 0;
    }
    for(i = 1; a[i] != '\0'; i++)
    {
        if((a[i] < '0') && (a[i] > '9'))
        {
            return 0;
        }
    }
    return 1;
}

double SpoctiPrumer(char retezec[])
{
    int hodnota = 0, velikost = VelikostRetezce(retezec), i = 0, platna_cisla = 0;

    if(velikost == 0)                                                                                 //KDYBY RETEZEC BYL PRAZDNY TAK VYSLEDEK PRUMER BUDE 0
    {
        return 0;
    }

    char pomocne_pole[velikost];
    while (i < velikost)
    {
        RetezecKopieCast(retezec, i, pomocne_pole, ' ');

        if(jeStringValidni(pomocne_pole) == 0)
        {
            return 0;
        }

        hodnota = hodnota + StringNaInt(pomocne_pole);
        i = i + VelikostRetezce(pomocne_pole) + 1;
        platna_cisla++;
    }
    return (double)hodnota/(double)platna_cisla;
}

int main()
{
    printf("Prumer je: %f\n", SpoctiPrumer("0 11 222 33333 44444 555555 6666666"));
    printf("Program vytvoren uzivatelem Lukas Netreba");
    return 0;
}
