#include <stdio.h>
#define velikost 10

int main()
{

    int i;
    int pole[velikost] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}; //pole stare
    int pole2[velikost];        //pole nove, do ktereho to utridim


    printf("Puvodni poradi pole bylo: ");
    printf("|");
    for (i = 0; i < velikost; i++)  //vypis stareho pole
    {
        printf("%i|", pole[i]);
    }


    for (i = 0; i < velikost; i++)
    {
        pole2[velikost - 1 - i] = pole[i];
    }


    printf("\nSetridene pole obracene je: ");
    printf("|");
    for (i = 0; i < velikost; i++)      //vypis noveho pole
    {
        printf("%i|", pole2[i]);
    }

    printf("\n");
    return 0;
}
