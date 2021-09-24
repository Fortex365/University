#include <stdio.h>
#define velikost 8

int main()
{

int i = 0, j = 0, x;
int pole[velikost] = {1, 2, 3, 4, 5, 6, 7, 8, 9}; //pole stare
int field[velikost];        //pole nove, do ktereho to utridim

    printf("Puvodni poradi pole bylo: ");
    for (i = 0; i < velikost; i++)  //vypis stareho pole
    {
        x = pole[i];
        printf(" %i", &x);
    }


        j = velikost - 1;
        for (i = 0; i < velikost; i++)      //prohozeni poradi pole
        {
            field[j] = pole[i];
            j--;
            if (j == 0)
            {
              break;
            }
        }

    printf("\nSetridene pole obracene je: ");
    for (i = 0; i < velikost; i++)      //vypis noveho pole
    {
        x = field[j];
        printf(" %i", &x);
    }
    return 0;
}
