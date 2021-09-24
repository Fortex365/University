#include <stdio.h>

int main () {
long int datum;
printf("Zadejte prosim vase datum narozeni ve formatu DDMMYYYY:\n");
scanf("%s", &datum);


/*Den*/
long int a;
a = datum/1000000;
printf("Den %i\n",a);


/*Mìsíc*/
long int b, c, d;
b = a*10;
c = datum/10000;
d = c - b;
printf("Mesic %i\n", d);


/*Rok*/
long int e, f;
e = c*10000;
f = datum - e;
printf("Rok %i\n", e);

return 0;

}

