#include <stdio.h>

int main(){
float a, b;

printf("Zadejte cislo a: ");
scanf("%f",&a);

printf("Zadejte cislo b: ");
scanf("%f",&b);

if (b != 0){
printf("Podil cisel je %f", a/b);
}
else {
printf("Nelze delit nulou!");
}

return 0;
}
