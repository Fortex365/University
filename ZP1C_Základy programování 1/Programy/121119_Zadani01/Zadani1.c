#include <stdio.h>

int main()
{
    int n, j, count, c;
    printf("Zadejte cislo n: ");
    scanf("%i",&n);

    j = 3;
    if ( n >= 1 )       //pojistka pro prvni prvocislo
   {
      printf("\nPrvnich %d prvocisla jsou: \n",n);
      printf("2 ");
   }

   for (count = 2; count <= n;  )    //vypise vsechny prvocisla, count od dvou protoze prvni n prvo cislo to vypsalo v ifu nad tim
   {
      for (c = 2; c <= j - 1;c++)
      {
         if (j%c == 0)      //cislo je suda, neni prvocislo, skace na konec breaku, if neplati da se j++
            break;
      }
      if (c == j)   //je prvocislo, vypise se
      {
         printf("%d ",j);
         count++;
      }
      j++;
    }
return 0;

}
