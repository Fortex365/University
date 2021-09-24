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
		
		mov ebx, 3; //Pr�m�r sou�tu t�� ��sel je d�len jejich po�tem
		mov edx, 0; //Clear edx pro edx:eax n�soben�
		cdq; //signed d�len�
		idiv ebx; //(a+b+c)/3
	}
}

short avg_short(short a, short b, short c) {
	_asm {
		movsx eax, a; //a, dopln�n� signed na 32b
		movsx ebx, b; //b, dopln�n� signed na 32b
		add eax, ebx; //a+b
		movsx ebx, c; //c, dopln�n� signed na 32b
		add eax, ebx; //a+b+c

		mov ebx, 3; //Pr�m�r sou�tu t�� ��sel je d�len jejich po�tem
		mov edx, 0; //Clear edx pro edx:eax n�soben�
		cdq; //signed d�len�
		idiv ebx; //(a+b+c)/3
	}
}

unsigned char last_digit(unsigned short n) {
	_asm {
		movzx eax, n; //na�teme vstup, dopln�me ho na 32b
	Start:
		CMP eax, 10; //Porovn�n� zda n < 10
		JB Konec; //Pokud ano, tak sk��eme na konec s t�m, �e n u� je lastdigit
		sub eax, 10; //Jinak ode��t�me des�tku, a pos�l�me ho start znovu na compare
		jmp Start
	Konec:
	}
}

	int projectile_motion_h(int h, unsigned short t, unsigned char g){
		_asm {
			movzx esi, h; //Ulo��me si h na pozd�ji (jestli�e je h = vzd�lenost, nem��e b�t z�porn�)

			//(g*t*t)
			movzx eax, t; //Ulo��me t s dopl�kem nul na 32b	
			mov edx, 0; //Clear edx, pro �plnost
			mul eax; //eax*eax (t*t)
			movzx ebx, g; //Ulo��me si g s dopl�kem nul na 32b
			mov edx, 0; //Clear edx, pro �plnost
			mul ebx; //Vyn�sob�me (t*t)*g

			mov ebx, eax; //Do ebx t*t*g
			mov eax, esi; //do eax h
			sub eax, ebx; //h-t*t*g
			shr eax, 1; //Meziv�sledek vyd�l�me dv�ma
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