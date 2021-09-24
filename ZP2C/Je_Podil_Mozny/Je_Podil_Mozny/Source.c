#include <stdio.h>

int IsPodilPossible(int a, int b) {
	int rem;
	if (a % b == 0) {
		return a % b;
	}
	else {
		return -1;
	}
}

int main() {
	int first = 10;
	int second = 20;

	IsPodilPossible(first, second);
	return 0;
}