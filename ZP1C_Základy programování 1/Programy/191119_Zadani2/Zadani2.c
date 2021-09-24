#include <stdio.h>
#define velikost 30

int nejblizsi_vyssi_prvocislo(int prirozene)
{
    int i, j, k, hledany;
    int pole[velikost];

    for(k = 0; k < prirozene; k++) //VYGENEROVANI POLE O VSECH HODNOTACH DO PRIROZENEHO CISLA
    {
        pole[k] = k;
    }

    for(j = 1; j < prirozene;j++)   //ODSTRANENI VSECH NASOBKU TOHOTO CISLA V POLI
    {
        for(i = 0; i < velikost; i++)
        {
            if(pole[i] = j*i)
            {
                pole[i] = 0;
            }
        }
    }

    hledany = prirozene;        //VYMYSLET NALEZENI PRVNIHO CISLA, KTERE JE VETSI JAK HLEDANY A NENI NULA
    for(i = 0; hledany < velikost; i++)
    {
        if(pole[i] == 0)
        {
            break;
        }
        if((pole[i] != 0) && (pole[i] > hledany))
        {
            return pole[i];
        }
    }
}

int main()      //OD ZADANEHO CISLA ODECTEME JEHO NEJBLIZSI VYSSI PRVOCISLO
{
    int cislo, vysledek;
    printf("Zadejte cislo: ");
    scanf("%i", &cislo);
    printf("\nVase cislo a rozdil od nejblizsiho vetsiho prvocisla je: ");

    vysledek = cislo - nejblizsi_vyssi_prvocislo(cislo);
    printf("%i", vysledek);
}
