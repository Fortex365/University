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

void RetezecKopieCast(char vstup[], int pocatek, char vystup[], char znak)
{
    int i = 0;
    while ((vstup[pocatek + i] != znak) && (vstup[pocatek + i] != '\0'))
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

JeVhodneZadan(char a[])
{
    int j;
    if((a[0] != '-') && ((a[0] < '0') || (a[0] > '9')))              //POKUD BY BYL SPRAVNE NEZADANY VSTUP, VYJIMKOU JE ZNAK MINUS NA NULTE POZICI V POLI
        {
            return 0;
        }
        int velikost2 = VelikostRetezce(a);
        for(j = 1; j <= velikost2; j++)
        {
            if((a[j] < '0') && (a[j] > '9'))
            {
                return 0;
            }
        }
}

double SpoctiPrumer(char retezec[])
{
    int hodnota = 0, velikost = VelikostRetezce(retezec), i = 0, platna_cisla = 0, j;

    if(velikost == 0)                                                                                 //KDYBY RETEZEC BYL PRAZDNY TAK VYSLEDEK PRUMER BUDE 0
    {
        return 0;
    }

    char pomocne_pole[velikost];
    while (i < velikost)
    {
        RetezecKopieCast(retezec, i, pomocne_pole, ' ');  //vytvori pomocne pole typu char se vsemi znaky ze vstupniho pole, do prvni mezery
        if(JeVhodneZadan(pomocne_pole))
        {
            return 0;
        }
        hodnota = hodnota + StringNaInt(pomocne_pole);      //SUMA hodnot
        i = i + VelikostRetezce(pomocne_pole) + 1;          //je treba se posunout za mezeru, v tom vstupnim retezci
        platna_cisla++;                                     //Platne cisla na vypocet prumeru
    }
    return (double)hodnota/(double)platna_cisla;
}

int main()
{
    char retezec[] = "0 11 222 33333 44444 555555 6666666";
    printf("Prumer je: %f\n", SpoctiPrumer(retezec));
    printf("Program vytvoren uzivatelem Lukas Netreba");
    return 0;
}
