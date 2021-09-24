#include <stdio.h>

int main(){
int a = 5, b = 1, c = 3, foo = 10;

if (a > b){
    if (b > c){
        foo = b;
        printf("foo je %i", foo);
}
}
else {
    foo = c;
    printf("foo je %i", foo);
}
return 0;
}
