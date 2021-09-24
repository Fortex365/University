#include <stdio.h>

int main()
{
    float a, b, PODIL, ROZDIL, SOUCIN, SOUCET;
    printf("Zadejte libovolna dve cisla ");
    scanf("%f", &a);
    scanf("%f", &b);

    PODIL = a/b;
    ROZDIL = a-b;
    SOUCIN = a*b;
    SOUCET = a+b;

    if (b == 0)
    {
        printf("Nelze delit nulou!\n");
        printf("Soucet: %f, Rozdil: %f, Soucin: %f", SOUCET, ROZDIL, SOUCIN);
    }
    else
    {
       printf("Soucet: %f, Rozdil: %f, Soucin: %f, Podil: %f ", SOUCET, ROZDIL, SOUCIN, PODIL);
    }
    return 0;
}
