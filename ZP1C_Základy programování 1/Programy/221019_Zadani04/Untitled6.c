#include <stdio.h>
#define velikost 2

int main()
{
    int i, j, x;
    int pole[velikost] = {5, 1, 5};
    int field[velikost] = {1, 5, 1};

    for (i = 0; i < velikost; i++) //prvni cyklus i = 1
    {
        for (j = 0; j < velikost; j++) //vnitrni cyklus s i = 1 a j <0,velikost>
        {
            if (pole[i] == field[j])
            {
                printf("Zadane pole jsou stejna, avsak hledana cisla se nemusi nachazet na stejnem indexu.");
                return 0;
            }
        }
    }
    printf("Zadana pole nemaji nic spolecneho na zadnem indexu!");
    return 0;
}

