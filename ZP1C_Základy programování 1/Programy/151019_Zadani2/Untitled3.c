#include <stdio.h>

int main()
{
    int a, b, i, p;     //prvni for
    int p0 = 1;     //druhe for
    int minula = 1, predminula = 0, soucasna;   //treti for
    int soucet = 0;     //ctvrte for
    int j = 0, g;   //pate for

    printf("Zadejte cisla a: ");        //uzivatelsky vstup hodnot parametru
    scanf("%i",&a);
    printf("Zadejte cisla b: \n");
    scanf("%i",&b);


    for (i = 0; i <= a; i++)        //vyp�e prvn�ch a n�sobk� ��sla b
    {
        p = i * b;
        printf("%i ", p);
    }


    for(i = 0; i < a; i++)           //spo��t� a-tou mocnicu ��sla b
    {
        p0 = p0*b;
    }
    printf("\nSpocitana a-ta mocnina cisla b je %i", p0);


    for(i = 1; i < a; i++)          //vypocet a-teho Fibonacciho cisla (1 1 2 3 5 8 13 21 34)
    {
     soucasna = predminula + minula;
     minula = soucasna;
     predminula = minula;
    }
    printf("\na-te Fibonacciho cislo je %i ", soucasna);


    for(i = 0;i < 100; i++)          //se�te v�echna ��sla v�t�� ne� "a" a men�� ne� "b"
    {
        if ((i > a) && (i < b))
            soucet = soucet + i;
    }
    printf("\nSectena vsechna cisla > a zaroven < b:%i ", soucet);


    if (a%1000 == 0)
        printf("\nZadane cislo je ctyrciferne ");
    if (a%100 == 0)
        printf("\nZadane cislo je triciferne ");
    if (a%10 == 0)
        printf("\nZadane cislo je dvouciferne ");
    else
        printf("\nZadane cislo je jednociferne ");

return 0;
}
