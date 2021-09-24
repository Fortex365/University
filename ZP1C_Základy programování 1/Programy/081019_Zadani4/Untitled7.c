#include <stdio.h> /*Import knihovny*/

int a, b, c;    /*Deklarace promenych*/
int x, y, z;

int main()
{
printf("Zadejte vsechny tri strany trojuhelniku: "); /*Vyzva k zadani tri hodnot od uzivatele*/
scanf("%i", &a);
scanf("%i", &b);
scanf("%i", &c);

    if (a < b)      /*Vyhodnocovaci strom pro nejmensi cislo*/
        x = a;
    else
        z = b;
    if (b < a)
        x = b;
    else
        z = a;
    if (a < c)
        x = a;
    else
        z = c;
    if (c < a)
        x = c;
    else
        z = a;


        if (a < x) /*Vyhodnocovaci strom pro druhe nejmensi cislo */
            y = a;
        else
            z = x;
        if (b < x)
            y = b;
        else
            z = x;
        if (c < x)
            y = c;
        else
            z = x;


if ((x + y > z)) /*Kdyz alespon jeden soucet jakychkoliv dvou stran je vetsi nez strana treti, je to trojuhelnik*/
{
    printf("Jedna se o trojuhelnik\n");


    if ((a != b) && (a != c) && (b != c)) /*Zadne dve strany nejsou stejne, bude to obecny trojuhelnik*/
    {
        printf("Navic se jedna o OBECNY trojuhelnik");
    }
    else
    {


     if ((a == b) || (a == c) || (b == c)) /*Alespon jakekoliv dve strany jsou stejne, jedna se o rovnostranny trojuhelnik*/
     {
        printf("Navic se jedna o ROVNOSTRANNY trohuhelnik");
     }
     else /*Jina nez treti moznost nezbyva, musi byt uz pouze pravouhly trojuhelnik*/
     {
         printf("Navic se jedna o PRAVOUHLY trojuhelnik");
     }
    }
}




else
{
    printf("Nejedna se o trojuhelnik");
}


return 0;
}
