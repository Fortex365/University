#include <stdio.h>

int main()
{
    char retezec[11];   //maximalni delka slova 10 pismen
    int i, help_value = 11;

    printf("Zadejte prosim palindrom: ");
    scanf("%10s", retezec);

    if (retezec[i] != retezec[10])  //pokud se prvni a posledni hned nerovna, neni to instantne palindrom
    {
        printf("Není palindrom!");
        return 0;
    }

    for (i = 0; i < 11; i++)
    {
        help_value--;
        if (retezec[i] == retezec[help_value])
        {
            continue;
        }
        if (retezec[i] == 10/2)
        {
            break;
        }
    }
    printf("Je palindrom");
    return 0;
}
