#include <stdio.h>
#define velikost 20
int main(int argc,const char * argv[]) {

    char pole[velikost];
    int i = 0, sifra;

    printf("text: ");
    scanf("%s",pole);
    while (getchar() != '\n');
    printf("Posun: ");
    scanf("%d", &sifra);

    while (pole[i]) {
        pole[i] += sifra;
        if (pole[i] > 'z') {
            pole[i] -= 'z' - 'a' + 1;
        }
        i++;
    }
    printf("%s\n", pole);


    return 0;
}
