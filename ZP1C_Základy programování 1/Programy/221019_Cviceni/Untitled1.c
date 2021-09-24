#include <stdio.h>

int main()
{
    int pole[10];
    int hledany, index, i;

    printf("Zadejte hodnoty do pole o velikosti 10: \n");
    for (i = 0; i < 10; i++)
    {
        scanf("%i", &pole[i]);
        printf("Zadejte dalsi hodnotu: \n");
    }

    printf("\nZadejte hledanou hodnotu v poli: ");
    scanf("%i", &hledany);

    for (i = 0; i < 10; i++)
    {
        if(pole[i] == hledany)    //nevidim duvod proc by to sem nemohlo jit
        {
            index = i;
            printf("Hledany index je %i ", index);
            break;
        }
    }
    return 0;
}
