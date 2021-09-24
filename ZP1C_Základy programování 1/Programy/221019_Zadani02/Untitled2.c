#include <stdio.h>
#define velikost 3

int main()
{
    float pole[velikost];
    int i;
    float v;

    printf("Zadejte hodnoty do pole: ");  //cyklus pro vyplneni pole
    for (i=0; i < velikost; i++)
    {
        if (i > 0)
        {
            printf("\nZadejte dalsi cislo do pole: ");

        }
        scanf("%f", &pole[i]);
    }


    v = 0;
   for (i = 0; i < velikost; i++)   //cyklus pro vypocet sumy celeho pole
   {
       v = v+pole[i];
   }
    printf("\nAritmeticky prumer je: %f", v/velikost);      //vypist arith. prumeru
    return 0;
}
