#include <stdio.h>
int minimum (int list[])
{
  int min = 0;
  for (int i = 0; i < 10; i++)
  if (list[i] < list[min])
  min = i;
  return min;
}

void int Setrid(int arr[])
{
    int pole[10];
    int i;
    for(i = 0; i <= 10; i++)
    {
        pole[i] = minimum(arr);
    }
}

int main()
{
    int pole[10] = {5, 4, 9, 7, 1, 2, 3, 6, 8, 0};
    Setrid(pole);
    int i;
    for(i = 0; i <= 10; i++)
    {
        printf("|%i|", pole[i]);
    }
    return 0;
}
