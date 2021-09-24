#include <stdio.h>

int main(){
int a;
printf("Zadejte cislo: ");
scanf("%i", &a);

switch (a)
{
case 1:
    printf("jedna");
    break;
case 2:
    printf("dva");
    break;
case 3:
    printf("tri");
    break;
case 4:
    printf("ctyri");
    break;
case 5:
    printf("pet");
    break;
case 6:
    printf("sest");
    break;
case 7:
    printf("sedm");
    break;
case 8:
    printf("osm");
    break;
case 9:
    printf("devet");
    break;
default:
    printf("Cislo neni v platnem rozsahu");
}
return 0;
}
