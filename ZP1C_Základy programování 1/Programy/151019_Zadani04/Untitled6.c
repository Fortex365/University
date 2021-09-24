#include <stdio.h>

int main() {
    int tisicovky, stovky, desitky, jednotky, i;
    for (i = 1000; i < 10000; i++) {

        tisicovky = i / 1000;
        stovky = i / 100 - tisicovky * 10;
        desitky = i / 10 - stovky * 10 - tisicovky * 100;
        jednotky = i - desitky * 10 - stovky * 100 - tisicovky * 1000;

        if ((tisicovky + stovky + desitky + jednotky) % 7 == 0) {
            printf("%d\n", i);
        }
    }

    return 0;
}
