#include <stdio.h>
#include <math.h>
int KvadrRx1(int a,int b,int c)
{
    int D;
    D = (b*b)-(4*a*c);
    float x1;
    x1 = (-b+sqrt(D))/2*a;
    return x1;
}

int KvadrRx2(int a,int b,int c)
{
    int D;
    D = (b*b)-(4*a*c);
    float x2;
    x2 = (-b-sqrt(D))/2*a;
    return x2;
}

int main()
{
    int a, b, c;
    printf("Zadejte cislo a: ");
    scanf("%i", &a);
    printf("Zadejte cislo b: ");
    scanf("%i", &b);
    printf("Zadejte cislo c: ");
    scanf("%i", &c);

    float x1, x2;
    x1 = KvadrRx1(a, b, c);
    x2 = KvadrRx2(a, b, c);
    printf("Koreny jsou %f a %f", x1, x2);
    return 0;
}
