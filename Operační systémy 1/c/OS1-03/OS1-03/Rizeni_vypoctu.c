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
		movsx eax, b; //nov� return value kdy� b > a
		jmp end;
	a_wins: // a > b, v eax u� a je
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
		movzx eax, b; //b<a dosad�me ho jako nov� eax
		jmp next; //pokra�ujeme dal�� iterac�
	round_one: //��ko bylo men��, z�stane v eax
		movzx eax, a;
		jmp next;
	next: //M�me nov�ho v�t�ze z prvn�ho kola v eax
		cmp eax, ecx; //Porovn�v�n� nov�ho v�t�ze s c
		jle new_a_wins;
		movzx eax, c; // (round-1 winner) < c, posledn� nov� eax
		jmp end;
	new_a_wins: //Kone�n� v�t�z (nejmen�� ��slo)
		jmp end;
	end: //returning eax jako nejmen�� ��slo z argument� funkce
	}

}

int kladne(int a, int b, int c) {
	_asm {
		movsx eax, a;
		movsx ebx, b;
		movsx ecx, c;

		cmp eax, 0;
		jge first_pass; //Jestli�e prvn� argument je kladn�
		mov eax, 0; //Prvn� argument nen� kladn�, zkr�cen�m vyhodnocov�n�m kon��me
		jmp end;
	first_pass:
		cmp ebx, 0;
		jge second_pass; //Jestli�e druh� argument je tak� kladn�
		mov eax, 0; //Druh� argument nen� kladn�, kon��me
		jmp end;
	second_pass:
		cmp ecx, 0;
		jge third_pass; //Jestli�e t�et� je tak� kladn�
		mov eax, 0; //T�et� nen� kladn�, kon��me
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
		jz m_zero; //Jestli�e m = 0 => n = 1 a konec
		jmp mocni; //Jinak je mocnina vy��� ne� 0, ni��� nem��e b�t d�ky unsigned int
	mocni:
		cmp ebx, 1; //Jestli�e je mocnina jedna
		je end; //tak se kon�� a v eax u� je spr�vn� hodnota.
		imul ecx; //Kdy� mocnina je vy��� jak jedna, tak se eax vyn�sob� ecx
		dec ebx; //Sn�� se mocnina
		jmp mocni; //N�sob� se eax s ecx

	m_zero:
		mov eax, 1; //Kdy� mocnina byla 0, cokoliv na nultou je jedna
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