#include <stdio.h>

int main(){
int a, b, c, d, e;
printf("Zadejte t��cifern� ��slo:\n");
scanf("%i",&a);

b = a/100;
printf("Prvn� ��slo va�eho zadan�ho ��sla je %i\n", b);

c = a/10;
d = c*10;
e = a - d;
printf("Posledn� ��slo va�eho zadan�ho ��sla je %i\n", e);
return 0;
}
