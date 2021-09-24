#include <stdio.h>
#include <math.h>

int main()
{
    int n, i, konec, counter, nasobek, ir, j;
    printf("Zadejte, prosim, cislo n: ");
    scanf("%i", &n);

    for(i = 1; i <= n; i++) //vypsat n prvku
    {
        printf("|%i|", i);
    }

    printf("\n");       //A0=1, k = +2, dokud < n+1
    konec = n + 1; //chceme vypsat n+1 prvku
    for(i = 1; i <= konec; i = i + 2)
    {
        printf("|%i|", i);
        konec++;
    }

    printf("\n");       //A0=1, k = +4, dokud < n+1
    konec = 0;
    for(i = 1; konec != n + 1; i = i + 4)
    {
        printf("|%i|", i);
        konec++;
    }

    printf("\n");   //A0=1, A1=A0+PocetPrubehuCyklu
    konec = 0;
    counter = 0;
    ir = 1;
    for(i = 0; konec != n + 1;i++)
    {
        printf("|%i|", i+ir);
        ir = ir + counter;
        counter++;
        konec++;
    }

    printf("\n");
    printf("|1|");
    konec = 0;
    for(i = 1; konec != n ; i++)
    {
        counter = pow(2, i);
       printf("|%i|", counter);
       konec++;
    }
    return 0;
}
