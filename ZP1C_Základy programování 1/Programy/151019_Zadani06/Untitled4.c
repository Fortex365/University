#include <stdio.h>

int main()
{
    int n, i, j, count, c;
    printf("Zadejte cislo n: ");
    scanf("%i",&n);


    printf("Cislo n je delitelne cisly: \n");         //vypíše všechny delitele cisla n
    for (i = 1; i <= n; i++)
    {
        if (n%i == 0)
        {
            printf("%i ", n/i);
            continue;
        }
    }

    j = 3;
    if ( n >= 1 )       //pojistka pro prvni prvocislo
   {
      printf("\nPrvnich %d prvocisla jsou: \n",n);
      printf("2\n");
   }

   for (count = 2; count <= n;  )    //vypise vsechny prvocisla, count od dvou protoze prvni n prvo cislo to vypsalo v ifu nad tim
   {
      for (c = 2; c <= j - 1;c++)
      {
         if (j%c == 0)
            break;
      }
      if (c == j)
      {
         printf("%d\n",j);
         count++;
      }
      j++;
    }
return 0;
}
