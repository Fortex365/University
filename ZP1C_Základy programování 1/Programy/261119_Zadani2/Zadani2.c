#include <stdio.h>
int JeSude(int a)
{
  if(a % 2 == 0)
    return 1;
  else
    return 0;
}

int main()
{
    int a, v;
    printf("Zadejte cislo: ");
    scanf("%i", &a);

    v = JeSude(a);
    if(v == 1)
        printf("Zadane cislo je sude");
    else
        printf("Zadane cislo je liche");
    return 0;
}
