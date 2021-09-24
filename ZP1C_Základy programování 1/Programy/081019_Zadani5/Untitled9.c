#include <stdio.h>

int main()
{
    int a, b, c;
    int x, y, z;
    printf("Zadejte tri cisla pro zjisteni dvou nejmensich:");
    scanf("%i", &a);
    scanf("%i", &b);
    scanf("%i", &c);

    if (a < b)
        x = a;
    if (b < a)
        x = b;
    if (a < c)
        x = a;
    if (c < a)
        x = a;

    if (a < x)
        y = a;
    if (b < x)
        y = b;
    if (c < x)
        y = c;

    printf("Dve nejmensi cisla jsou %i a druhe %i", x, y);
    return 0;
}
