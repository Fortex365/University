#include <stdio.h>

int main()
{
    char retezec[] = "Tohle je zadany retezec";
    int i, delka, mezera, souhlaska, samohlaska;

    while (retezec[delka] != 0)
        delka++;

    for(i = 0; i < delka; i++)
    {
        if (retezec[i] == ' ')
        {
            mezera++;
        }
        if ((retezec[i] == 'a') || (retezec[i] == 'e')
            || (retezec[i] == 'i') || (retezec[i] == 'o')
            || (retezec[i] == 'u')|| (retezec[i] == 'y'))
        {
            samohlaska++;
        }
        else
        {
            souhlaska;;
        }
    }
    printf("Pocet mezer je %i, souhlasek %i, samohlasek %i", mezera, souhlaska, samohlaska);
    return 0;
}
