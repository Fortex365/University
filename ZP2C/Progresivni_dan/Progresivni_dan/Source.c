#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

void countFee(unsigned number) {
	 float fee10 = 0.1;
	 float fee20 = 0.2;
	 float fee20_and_more = 0.3;

	unsigned int sum_of_all = 0;
	unsigned int below10 = 0;
	unsigned int between10and20 = 0;
	unsigned int above20 = 0;

	if (number <= 10000) {
		below10 = number * fee10;
	}

	if (number > 1000 && number < 20000) {
		between10and20 = number * fee20;
	}

	if (number >= 20000) {
		above20 = number * fee20_and_more;
	}

	sum_of_all = below10 + between10and20 + above20;
	printf("Your progressive fee is: ");
	printf("%i\n", sum_of_all);

}

int main() {	
	unsigned int income = 0;
	printf("Please input your income: ");
	scanf("%i", &income);

	countFee(income);
}