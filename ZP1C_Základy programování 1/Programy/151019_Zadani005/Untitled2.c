#include <stdio.h>
#include <stdlib.h>

int main()
{
    char cislo[4];

    printf("Zadejte cislo: \n");
    scanf("%4s", cislo);

    printf("Cislo vypsane pozpatku: \n");
    printf("%c", cislo[3]);
    printf("%c", cislo[2]);
    printf("%c", cislo[1]);
    printf("%c", cislo[0]);

    return 0;
}

