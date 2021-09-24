#include <stdio.h>

int main() //vypíše souèet dvouciferných lichých èísel
{
    int a = 0, i;
    for(i = 10; i <=100; i++)
    {
        if (i%2 !=0)
        {
            a = a + i;
            printf("\n%i ", a);
            continue;
        }
    }
    return 0;
}
