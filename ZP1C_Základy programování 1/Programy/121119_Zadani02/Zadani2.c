#include <stdio.h>
#define velikost 20

int main()
{
    int n, i = 0, prvocislo = 0,x = 0;
    int pole[velikost];
    printf("Zadejte, prosim, cislo n: ");
    scanf("%i", &n);

    if ((n < 2) || (n >= 20))
    {
        printf("Parametr n byl nevhodne zadan!");
        return 0;
    }

    printf("Pole je: ");
    printf("|");
    for(i = 2; i < velikost; i++) //vytvoøí pole od A0 = 2, k = +1 dokud < n
    {
        pole[x] = i;
        x++;
        printf("%i|", pole[i]);
    }

    printf("\nPrvocisla z pole jsou: ");
    if(pole[prvocislo] != n)
    {
        printf("%i ", pole[prvocislo]);
        for(i = pole[prvocislo] + 1; i < n; i++)
        {
            if((pole[i]%pole[prvocislo]) == 0)
            {
                pole[i] = '\0';      //NASOBEK NENI PRVOCISLO
            }
        }
        prvocislo++;
    }
    return 0;
}
