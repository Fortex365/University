#include <stdio.h>
#include <math.h>

int main()
{
    int n, i, mocnina;
    float v, x;
    printf("Zadejte cislo n podle ktereho se bude odvijet presnot cisla PI: ");
    scanf("%i", &n);

    for(i = 1;i < n; i++)
    {
        x = v;
        mocnina = pow((-1), i);
        v = (mocnina)/(2*i+1);
        v = x + v;
        printf("%f ", v);
    }
  return 0;
}
