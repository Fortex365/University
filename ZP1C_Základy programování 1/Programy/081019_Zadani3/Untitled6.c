#include <stdio.h>

int main()
{
    int a, x, x2, x3;
    printf("Zadejte aktualni rok: ");
    scanf("%i", &a);

x = a%4;

    if (x == 0)
    {
     x2 = x%100;
     if (x2 == 0)
     {
        x3 = x2%400;
        if (x3 ==0)
        {
        printf("Zadany rok je prestupny");
        }
        else
        {
        printf("Zadany rok NENI prestupny");
        }
     }
     else
     {
        printf("Zadany rok je prestupny");
     }
    }
    else
    {
     printf("Zadany rok NENI prestupny");
    }
return 0;
}
