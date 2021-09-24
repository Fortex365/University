//Vytvoreno od Lukas Netreba
//Verze ze dne 06.11.2019

#include <stdio.h>
#define velikost 32

int main ()                            //prevod cisla do jine ciselne soustavy
{
    int cislo, soustava;
    char pole[velikost];
    int j, i, ir, pomocna_promenna;   //inicializace prg. promennych


    printf("Zadejte, prosim, prirozene cislo: ");
    scanf("%i",&cislo);              //vyzadana hodnota cisla pro prevod, od uzivatele
    printf("Do jake soustavy chce cislo prevest? Mate na vyber soustavy (2 az 16): ");
    scanf("%i",&soustava);          //vyzadana hodnoty ciselne soustavy do ktere se ma prevod uskutecnit, od uzivatele


    if ((cislo < 0) || (soustava < 2) || (soustava > 16))
    {
        printf("Alespon jeden z parametru byl nevhodne zadan!\n");
        return 0;
    }

    if(cislo == 0)
    {
        printf("Vysledek je cislo: 0");
        return 0;
    }


        j = 0;
        pomocna_promenna = 0;           //je zavedena pro cyklus vypsani vysledku (zbytku po deleni) odzadu
        for(i = 0; cislo > 0; i++)
        {
            ir = cislo % soustava;      //napr. 10%2 je 0, 5%2 je 1, 2%2 je 0, 1%2 je 1 ...cist vysledek obracene!
            cislo = cislo / soustava;
                if(ir < 10)
                {
                    ir = '0' + ir;
                    pole[j] = ir;       //uklada nam zbytky po deleni do pole
                    j++;
                    pomocna_promenna++;
                }
                else
                {
                    switch (ir)
                    {
                    case 10:
                        pole[j] = 'A';
                        j++;
                        pomocna_promenna++;
                        break;
                    case 11:
                        pole[j] = 'B';
                        j++;
                        pomocna_promenna++;
                        break;
                    case 12:
                        pole[j] = 'C';
                        j++;
                        pomocna_promenna++;
                        break;
                    case 13:
                        pole[j] = 'D';
                        j++;
                        pomocna_promenna++;
                        break;
                    case 14:
                        pole[j] = 'E';
                        j++;
                        pomocna_promenna++;
                        break;
                    case 15:
                        pole[j] = 'F';
                        j++;
                        pomocna_promenna++;
                        break;
                    default:
                    break;
                    }                       //ukonceni switche
                }                           //ukonceni elseif
            }                               //ukonceni cyklu for



        printf("Vysledek je cislo: ");      //vypsani vysledku, je treba cist odzadu
        for(j = pomocna_promenna - 1; j >= 0; j--)
        {
            printf("%c", pole[j]);
        }
        printf("\n");

return 0;
}

