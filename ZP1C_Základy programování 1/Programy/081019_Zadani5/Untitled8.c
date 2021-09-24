#include <stdio.h>

int main()
{
    int BODY;
    printf("Zadejte pocet bodu zaka: ");
    scanf("%i", &BODY);

if ((BODY <= 100) && (BODY >= 90))
    {printf("Vysledna znamka zaka je A");
}

if ((BODY <= 89) && (BODY>= 80))
{printf("Vysledna znamka zaka je B");
}

if ((BODY <= 79) && (BODY>= 76))
{printf("Vysledna znamka zaka je C");
}

if ((BODY <= 75) && (BODY>= 71))
{printf("Vysledna znamka zaka je D");
}

if ((BODY <= 70) && (BODY>= 60))
{printf("Vysledna znamka zaka je E");
}

if (BODY <= 59){printf("Vysledna znamka zaka je F");
}

default:
    printf("Zak je hodnocen vyrokem NEHODNOCEN");

return 0;
}
