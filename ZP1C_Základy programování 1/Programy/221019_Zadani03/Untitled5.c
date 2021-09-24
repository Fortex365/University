#include <stdio.h>
#define velikost 10

int main()
{
    int i, j = 0;
    int pole[velikost] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int field[velikost] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

    for (i = 0; i < velikost; i++)
    {
        if (pole[i] == field[i])
        j++;
        if (j == velikost)
        {
            printf("Pole 1 a pole 2 jsou shodna.");
            return 0;
        }
    }
    printf("Zadana pole jsou od sebe odlisna.");
    return 0;
}
