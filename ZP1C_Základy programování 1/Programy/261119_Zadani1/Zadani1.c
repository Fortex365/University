#include <stdio.h>
#define velikost 50

int main()
{
    int m, n, i;
    int pole[velikost] = {11, 22, 33, 44, 55, 66, 77, 88, 99, 101, 111, 121, 131, 141, 151, 161, 171, 181, 191, 202, 212, 222, 232, 242, 252, 262, 272, 282, 292, 303, 313, 323,343, 353, 363, 373, 383, 393}
    printf("Zadejte cislo (od) m: ");
    scanf("%i", &m);
    printf("Zadejte cislo (do) n: ");
    scanf("%i", &n);

    if((m < 11) &(n < 11))
    {
        printf("Jednociferne cislo neni palidrom, zadejte alespon dvojciferne cislo!");
        return 0;
    }

    for(i = m; i < n; i++)
    {

    }
}
