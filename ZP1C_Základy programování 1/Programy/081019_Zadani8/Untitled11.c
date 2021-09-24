#include <stdio.h>

int main()
{
    int a;
    printf("Zadejte hodnotu cisla a ");
    scanf("%i", &a);

    switch (a)
    {
    case 1:
        printf("1 ");
        break;
    case 2:
        printf("2 1 ");
        break;
    case 3:
        printf("3 2 1 ");
        break;
    case 4:
        printf("4 3 2 1 ");
        break;
    case 5:
        printf("5 4 3 2 1 ");
        break;
    case 6:
        printf("6 5 4 3 2 1 ");
        break;
    case 7:
        printf("7 6 5 4 3 2 1 ");
        break;
    case 8:
        printf("8 7 6 5 4 3 2 1 ");
        break;
    case 9:
        printf("9 8 7 6 5 4 3 2 1 ");
        break;
    case 10:
        printf("10 9 8 7 6 5 4 3 2 1 ");
        break;
    default:
        printf("Nevhodny rozsah!");
        break;
    }
    return 0;
}
