#include <stdio.h>

int over(int cislo)
{
    int a, b, vysledek;
    a = cislo/100;
    b = cislo%100;

    if((cislo%(a+b)) == 0)
    {
        return 1;
    }
    return 0;
}

int main()
{
    int i;
    printf("Ctyrciferna cisla xx delitelna yy:\n");
    for(i = 1000; i <=9999; i++)
    {
        if(over(i) == 1)
        {
            printf("%i ", i);
        }
    }
    return 0;
}
