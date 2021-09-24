#include <stdio.h>

int main()
{
    char retezec[] = "oko";
    int i, delka = 0, promenna;

    printf("Predikat palindromu '%s'", retezec);

    while (retezec[delka]) //zjisteni delky retezce, ktery uzivatel zadal
    {
        delka++;
    }

    for (i = 0; i < (delka/2); i++)
    {
        if (retezec[i] != retezec[delka-1-i])
        {
            printf("\nNeni palindromem");
            return 0;
        }
    }

    printf("\nJe palindromem");
    return 0;
}
