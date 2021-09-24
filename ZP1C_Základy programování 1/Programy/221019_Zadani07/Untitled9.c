#include <stdio.h>
#define velikost 10

int main()
{
    int i, a = 3, b = 1;    //hledama "a" nahrazujeme ho za "b"
    int pole[velikost] = {1, 2, 3, 1, 2, 3, 1, 2 , 3};

    for (i = 0; i < velikost; i++)      //cyklus ktery nahradi hodnotu "b" pokud na jakemkoliv indexu v poli se nachazi stejne hodnota s "a"
    {
        if (pole[i] == a)
        {
            pole[i] = b;
        }
    }

    printf("Nove hodnoty pole jsou: \n");
    for (i = 0; i < velikost; i++)      //cyklus vypsani celeho noveho pole
    {
        printf(" %i", pole[i]);
    }
    return 0;
}
