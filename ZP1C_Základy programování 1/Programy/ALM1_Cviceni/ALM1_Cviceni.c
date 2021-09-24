#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define velikost 100

int main()                                                                  //INSERTION SORT
{
    srand(time(0));     //DULEZITE PRO GENEROVANI OPRAVDU NAHODNEHO CISLA PRO KAZDE SPUSTENI PROGRAMU ZNOVA
    int n = 20, i = 0, j = 0, pomocna_promenna = 0;
    int pole[velikost];

    for(i = 0; i < n; i++)                                                  //VYGENEROVANI 20TI NAHODNYCH CISEL DO POLE
    {
        pomocna_promenna = rand()%100;
        pole[i] = pomocna_promenna;
    }

    printf("Dvacet nahodnych cisel pro setrizeni jsou: ");
    printf("|");
    for(i = 0; i < n; i++)                                                  //VYPIS PUVODNIHO POLE
    {
        printf("%i|", pole[i]);
    }

    for(j = 1; j < n; j++)                                                  //INSERTION SORT
    {
     pomocna_promenna = pole[j];
     i = j - 1;
            while((i >= 0) && (pole[i] > pomocna_promenna))
            {
                pole[i+1] = pole[i];
                i--;
            }
            pole[i+1] = pomocna_promenna;
    }

    printf("\nNove setrizene pole je: ");
    printf("|");                                                          //VYPIS NOVEHO SETRIZENEHO POLE INSERTION SORTEM
    for(i = 0; i < n; i++)
    {
      printf("%i|", pole[i]);
    }

    return 0;
}
