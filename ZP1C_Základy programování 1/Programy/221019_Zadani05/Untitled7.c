#include <stdio.h>
#define velikost 10

int main()
{
    int pole[velikost] = {9, 2, 9, 4, 9, 7, 3, 1, 6, 5, 8}; //lichy soucet je 43
    int i, soucet = 0;

    for (i = 0; i < velikost; i++)
    {
        if ((pole[i]%2) != 0)
        {
          soucet = soucet + pole[i];
        }
    }
    printf("Soucet lichych cisel v poli je %i.", soucet);
    return 0;
}
