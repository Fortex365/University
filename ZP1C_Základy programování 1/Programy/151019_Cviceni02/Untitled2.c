#include <stdio.h>

int main()
{
    int j;
    for(j = 0; j < 10; j++)
    {
        if(j%3 == 0)
        {
            continue;
        }
        printf("%i", j);
    }
return 0;
}
