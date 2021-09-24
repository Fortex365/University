#include <stdio.h>
#define velikost 11

int main()
{
    char retezec1[velikost];
    char retezec2[velikost];
    int i, znak, j;

    printf("Zadejte prosim prvni retezec: ");
    scanf("%10s", retezec1);
    printf("Zadejte prosim druhy retezec: ");
    scanf("%10s", retezec2);

    for (i = 0; i < 10; i++)
    {
        for (j = 0; j < 10; j++)
        {
            if (retezec1[i] == retezec2[j])
            {
                znak++;
            }

        }
    }
    printf("Maximalni pocet spolecnych znaku je: %i", znak);
    return 0;
}
