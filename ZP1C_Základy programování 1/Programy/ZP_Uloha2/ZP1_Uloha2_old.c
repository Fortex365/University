#include <stdio.h>

int StringNaInt(char []);
double spocti_prumer(char []);
int VelikostPole(char []);

int main()
{
    double prumer;
    char retezec[] = "0 11 22 3333 444444 555555 66666666";

    prumer = spocti_prumer(retezec);
    printf("Prumer je: %f", prumer);

    return 0;
}


double spocti_prumer(char retezec[])
{
    int i = 0, hodnota = 0, velikost = 0, j;

    velikost = VelikostPole(retezec);

    if(velikost == 0)                                                //KDYBY RETEZEC BYL PRAZDNY TAK VYSLEDEK PRUMER BUDE 0
    {
        return 0;
    }

    int CastPoleDoMezery[velikost];
    for(j = 0; j < velikost; j++)   //V CELEM POLI                                   //CTENI HODNOT V RETEZCI CHAR A JEJICH PREVOD NA INT
    {
        int promenna = 0;
        for(i = promenna; retezec[i] != ' '; i++)  //PREKOPIROVANI STARÉHO POLE DO NOVÉHO POLE (KTERÉ JE DO MEZERY) V DALŠÍM PRÙCHODU VYNECHÁVÁ PRÁVÌ TU MEZERU
            {
                CastPoleDoMezery[i] = retezec[i];
            }
        hodnota = hodnota + StringNaInt(CastPoleDoMezery);
        promenna++;
    }
    hodnota = hodnota/velikost;
    return hodnota;
}


int StringNaInt(char a[])
{
  int c, znamenko, posun, hodnota;

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

int VelikostPole(char a[])
{
    int velikost = 0;
    while(a[velikost] != '\0')
    {
        velikost++;
    }
    return velikost;
}
