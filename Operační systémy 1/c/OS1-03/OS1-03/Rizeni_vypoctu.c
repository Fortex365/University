#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>

int sgn(int i) {
	_asm {
		mov eax, i; //load
		cmp eax, 0; //if zero
		jz zero;
		cmp eax, 0;
		jg positive; //if greater than zero
		jmp negative; //else must be lesser than zero
	positive:
		mov ebx, 1; //result is 1
		jmp end;
	zero:
		mov ebx, 0; //result is 0
		jmp end;
	negative:
		mov ebx, -1; //result is -1
		jmp end;
	end:
		mov i, ebx; //returning value
	}
	return i;
}

char max2c(char a, char b) {
	_asm {
		movsx eax, a; //load
		movsx ebx, b;
		cmp eax, ebx; 
		jge a_wins; // a > b
		movsx eax, b; //nová return value když b > a
		jmp end;
	a_wins: // a > b, v eax už a je
		jmp end;
	end:
	}
}

unsigned short min3us(unsigned short a, unsigned short b, unsigned short c) {
	_asm {
		movzx eax, a; //loads
		movzx ebx, b;
		movzx ecx, c;

		cmp eax, ebx; // a<b
		jle round_one; 
		movzx eax, b; //b<a dosadíme ho jako nové eax
		jmp next; //pokraèujeme další iterací
	round_one: //Áèko bylo menší, zùstane v eax
		movzx eax, a;
		jmp next;
	next: //Máme nového vítìze z prvního kola v eax
		cmp eax, ecx; //Porovnávání nového vítìze s c
		jle new_a_wins;
		movzx eax, c; // (round-1 winner) < c, poslední nové eax
		jmp end;
	new_a_wins: //Koneèný vítìz (nejmenší èíslo)
		jmp end;
	end: //returning eax jako nejmenší èíslo z argumentù funkce
	}

}

int kladne(int a, int b, int c) {
	_asm {
		movsx eax, a;
		movsx ebx, b;
		movsx ecx, c;

		cmp eax, 0;
		jge first_pass; //Jestliže první argument je kladný
		mov eax, 0; //První argument není kladný, zkráceným vyhodnocováním konèíme
		jmp end;
	first_pass:
		cmp ebx, 0;
		jge second_pass; //Jestliže druhý argument je také kladný
		mov eax, 0; //Druhý argument není kladný, konèíme
		jmp end;
	second_pass:
		cmp ecx, 0;
		jge third_pass; //Jestliže tøetí je také kladný
		mov eax, 0; //Tøetí není kladný, konèíme
		jmp end;
	third_pass:
		mov eax, 1;
		jmp end;
	end:
	}
}

int mocnina(int n, unsigned int m) {
	_asm {
		movsx eax, n; //load
		movzx ebx, m;
		movzx ecx, n;
		
		cmp ebx, 0;
		jz m_zero; //Jestliže m = 0 => n = 1 a konec
		jmp mocni; //Jinak je mocnina vyšší než 0, nižší nemùže být díky unsigned int
	mocni:
		cmp ebx, 1; //Jestliže je mocnina jedna
		je end; //tak se konèí a v eax už je správná hodnota.
		imul ecx; //Když mocnina je vyšší jak jedna, tak se eax vynásobí ecx
		dec ebx; //Sníží se mocnina
		jmp mocni; //Násobí se eax s ecx

	m_zero:
		mov eax, 1; //Když mocnina byla 0, cokoliv na nultou je jedna
	end:
	}
}

void main() {
	printf("%d\n",sgn(-10));
	printf("%d\n",sgn(10));
	printf("%d\n",sgn(0));
	printf("\n");

	printf("%d\n", max2c(10,20));
	printf("%d\n", max2c(-10,20));
	printf("%d\n", max2c(10,-20));
	printf("%d\n", max2c(-10,-20));
	printf("\n");

	printf("%d\n", min3us(1,2,3));
	printf("%d\n", min3us(3,2,1));
	printf("\n");

	printf("%d\n", kladne(1,2,3));
	printf("%d\n", kladne(-1,2,3));
	printf("%d\n", kladne(1,-2,3));
	printf("%d\n", kladne(1,2,-3));
	printf("\n");

	printf("%d\n", mocnina(2,0));
	printf("%d\n", mocnina(2,1));
	printf("%d\n", mocnina(2,3));


}