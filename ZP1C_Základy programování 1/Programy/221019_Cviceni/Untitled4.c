#include <stdio.h>
#define velikost 10

int main()
{
    int pole[velikost];
    int hledany, i;

    printf("Zadejte hodnoty (po jedne) do pole o velikosti 10: \n");
    for (i = 0; i < velikost; i++)
    {
        if ((i > 0) && (i < velikost))
        {
            printf("Zadejte dalsi hodnotu: \n");
        }
        scanf("%i", &pole[i]);
    }

    printf("\nZadejte hledanou hodnotu v poli: ");
    scanf("%i", &hledany);

    for (i = 0; i < velikost; i++)
    {
        if(pole[i] == hledany)
        {
            printf("Hledany index je %i \n", i);
            return 0;
        }
    }
    printf("Hledany prvek neni v poli\n");
    return 0;
}
