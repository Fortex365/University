#include <stdio.h>

int main(){
int a, b, c, d, e;
printf("Zadejte tøíciferné èíslo:\n");
scanf("%i",&a);

b = a/100;
printf("První èíslo vašeho zadaného èísla je %i\n", b);

c = a/10;
d = c*10;
e = a - d;
printf("Poslední èíslo vašeho zadaného èísla je %i\n", e);
return 0;
}
