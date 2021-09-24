#include <stdio.h>

int main (){
int a, b, c;
printf("Nasledne zadejte tri hodnoty a, b, c: ");
scanf("%i", &a);
scanf("%i", &b);
scanf("%i", &c);

if ((a < b) && (a < c))
{
    printf("Nejmensi cislo je %i", a);
}
if ((b < c) && (b < a))
{
    printf("Nejmensi cislo je %i", b);
}
if ((c < b) && (c < a))
{
    printf("Nejmensi cislo je %i", c);
}


if (a == b)
{
    printf("Nejmensi cislo je %i", a);
}
if (a == c)
{
    printf("Nejmenci cislo je %i", a);
}
if (c == b)
{
    printf("Nejmenci cislo je %i", b);
}

return 0;
}
