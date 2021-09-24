#include <stdio.h>

int main()
{
    int i;
    int prvni, druha, treti, ctvrta;
    int a, b, c;

    for(i = 1000; i <10000; i++) //problém pokud nìjaká cifra je nula, protože já tam násobím vždycky s tou hodnotou
    {
    prvni = i / 1000; //nemusí se řešit
    druha = i / 100; //1 číslo před, 2 za
    treti = i / 10; // 2 čísla před, 1 za
    ctvrta = i / 1; //3 cisla před, 0 za

    a = prvni * 1000;

        if((prvni+druha+treti+ctvrta)%7 == 0)
            printf("%i ", i);
    }
    return 0;
}

