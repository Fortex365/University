#include <stdio.h>

double mocnina(double zaklad, int exponent)
{
    double vysledek = 1.0;
    int i;

    for(i = 0; i < exponent; i++)
    {
        vysledek = vysledek * zaklad;
    }
    return vysledek;
}

int main()
{

}
