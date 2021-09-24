#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>

int avg_int(int a, int b, int c) {
	_asm {
		mov eax, a; //a
		mov ebx, b; //b
		add eax, ebx; //a+b
		mov ebx, c; //c
		add eax, ebx; //a+b+c
		
		mov ebx, 3; //Prùmìr souètu tøí èísel je dìlen jejich poètem
		mov edx, 0; //Clear edx pro edx:eax násobení
		cdq; //signed dìlení
		idiv ebx; //(a+b+c)/3
	}
}

short avg_short(short a, short b, short c) {
	_asm {
		movsx eax, a; //a, doplnìní signed na 32b
		movsx ebx, b; //b, doplnìní signed na 32b
		add eax, ebx; //a+b
		movsx ebx, c; //c, doplnìní signed na 32b
		add eax, ebx; //a+b+c

		mov ebx, 3; //Prùmìr souètu tøí èísel je dìlen jejich poètem
		mov edx, 0; //Clear edx pro edx:eax násobení
		cdq; //signed dìlení
		idiv ebx; //(a+b+c)/3
	}
}

unsigned char last_digit(unsigned short n) {
	_asm {
		movzx eax, n; //naèteme vstup, doplníme ho na 32b
	Start:
		CMP eax, 10; //Porovnání zda n < 10
		JB Konec; //Pokud ano, tak skáèeme na konec s tím, že n už je lastdigit
		sub eax, 10; //Jinak odeèítáme desítku, a posíláme ho start znovu na compare
		jmp Start
	Konec:
	}
}

	int projectile_motion_h(int h, unsigned short t, unsigned char g){
		_asm {
			movzx esi, h; //Uložíme si h na pozdìji (jestliže je h = vzdálenost, nemùže být záporná)

			//(g*t*t)
			movzx eax, t; //Uložíme t s doplòkem nul na 32b	
			mov edx, 0; //Clear edx, pro úplnost
			mul eax; //eax*eax (t*t)
			movzx ebx, g; //Uložíme si g s doplòkem nul na 32b
			mov edx, 0; //Clear edx, pro úplnost
			mul ebx; //Vynásobíme (t*t)*g

			mov ebx, eax; //Do ebx t*t*g
			mov eax, esi; //do eax h
			sub eax, ebx; //h-t*t*g
			shr eax, 1; //Mezivýsledek vydìlíme dvìma
		}
	}

	unsigned char share_x(unsigned char x, unsigned short y) {
		_asm {
			movzx eax, x; //a
			movzx ebx, y; //b
			add eax, ebx; //a+b
			mov ebx, eax; //a+b do ebx
			mov eax, 100; // 100
			mov edx, 0; 
			div ebx; // 100/(a+b)
			movzx ebx, x;
			mul ebx;
		}
	}

int main()
{
	printf("Prumer: 3,6,9 -- %i\n", avg_int(3, 6, 9));
	printf("Prumer: -3,-6,-9 -- %i\n", avg_int(-3, -6, -9));
	printf("Prumer: 3,-6,9 -- %i\n", avg_int(3, -6, 9));

	printf("Prumer: 3,6,9 -- %i\n", avg_short(3, 6, 9));
	printf("Prumer: -3,-6,-9 -- %i\n", avg_short(-3, -6, -9));
	printf("Prumer: 3,-6,9 -- %i\n", avg_short(3, -6, 9));

	printf("Last digit 1475 -- %i\n", last_digit(1475));
	printf("Projectile motion 50,4,3 -- %i\n", projectile_motion_h(50,4,3));
	printf("Share-x 1:3 -- %i\n", share_x(1,3));

}