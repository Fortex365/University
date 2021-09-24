#include <stdio.h>

int main()
{
    int a;
    printf("Zadejte cislo: ");
    scanf("%i", &a);

    if (a < 0){
        a = a*(-1);
        printf("Absolutni hodnota cisla a je %i", a);
    }
    else {
        a = a;
        printf("Absolutni hodnota cisla a je %i", a);
    }
return 0;
}
