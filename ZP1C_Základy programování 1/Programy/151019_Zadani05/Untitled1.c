#include <stdio.h>
#include <stdlib.h>

int main()
{
    char cislo[4];

    printf("Zadejte cislo: \n");
    scanf("%3s", cislo);

    printf("Cislo vypsane pozpatku: \n");
    printf("%c", cislo[4]);
    printf("%c", cislo[4]);
    printf("%c", cislo[4]);
    printf("%c", cislo[4]);

    return 0;
}
