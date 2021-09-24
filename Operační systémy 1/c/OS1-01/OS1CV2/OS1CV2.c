#define _CRT_SECURE_NO_WARNINGS //KV�LI FUNKCI PRINTF


//IMPORTOV�N� KNIHOVEN

#include <stdlib.h>
#include <stdio.h>
#include <math.h>


//OBDELN�KY

int obvod_obdelnika(int a, int b) {
	_asm {
		mov eax, a; //Na�teme hodnotu strany a
		add eax, b; //P�id�me hodnotu strany b ke stran� a
		shl eax, 1; //Vyn�sob�me dv�ma
	}
}

int obsah_obdelnika(int a, int b) {
	_asm {
		mov eax, a; //Na�teme hodnotu strany a, do eax
		mul b; //Vyn�sob�me eax hodnotou b
	}
}


//�TVERCE

int obvod_ctverce(int a) {
	_asm {
		mov eax, a; //Na�teme hodnotu strany a
		shl eax, 2; //Vyn�sob�me ji 4mi 
	}
}

int obsah_ctverce(int a) {
	_asm {
		mov eax, a; //Na�teme hodnotu strany a
		mul a; //Vyn�sob�me sebou sam�m
	}
}


//TROJ�HELN�KY -- OBVODY

int obvod_trojuhelnika(int a, int b, int c) {
	_asm {
		mov eax, a; //Na�teme a
		add eax, b; //P�i�teme k meziv�sledku stranu b
		add eax, c; //P�i�teme k meziv�sledku stranu c
	}
}

int obvod_trojuhelnika2(int a) {
	_asm {
		mov eax, a; //Na�teme a
		add eax, a; //P�i�teme k meziv�sledku podruh� stranu a
		add eax, a; //P�i�teme k meziv�sledku pot�et� stranu a
	}
}


//TROJ�HELN�KY -- OBSAHY

int obsah_trojuhelnika2(int a, int b) {
	_asm {
		mov eax, a; //Na�teme a
		mul b; //Vyn�sob�me meziv�sledek (eax) s hodnotou b
		shr eax, 1; //Meziv�sledek vyd�l�me dv�ma
	}
}

int obsah_trojuhelnika3(int a, int va) {
	_asm {
		mov eax, a; //Na�teme a
		mul va; //Vyn�sob�me meziv�sledek hodnout v��ky strany a
		shr eax, 1; //Vyd�l�me meziv�sledek dv�ma
	}
}


//KRYCHLE

int objem_krychle(int a) {
	_asm {
		mov eax, a; //Na�teme a
		mul a; //Meziv�sledek vyn�sob�me sebou sam�m
		mul a; //Meziv�sledek vyn�sob�me sebou sam�m
	}
}


//HERON�V VZOREC

double Heron(int a, int b, int c) {
	int returnValue = 0;
	//int s = 0;
	_asm {
		//V�PO�ET PARAMETRU S
		mov eax, a; //Na�teme hodnotu a
		add eax, b; //P�i�teme k meziv�sledku b
		add eax, c; //P�i�teme k meziv�sledku c
		shr eax, 1; //Meziv�sledek vyd�l�me dv�ma
		mov ecx, eax; //Ulo�en� v�sledku s do ecx
		
		//V�po�et s(s-a)
		mov ebx, a; //Na�teme a
		sub eax, ebx; //Vypo�teme s-a 
		mov edx, ecx; //Do edx, hodnotu "s"
		mul edx; //Vypo�teme (s-a)*s
		mov returnValue, eax; //Do returnValue si ulo��me meziv�sledek (s-a)*s

		//V�po�et s(s-a)(s-b)
		mov ebx, b; //Na�teme b
		mov eax, ecx; //Na�teme si p�vodn� "s"
		sub eax, ebx; //Vypo�teme s-b
		mul returnValue; //Vyn�sob�me (s-b) s hodnotou meziv�sledku (s-a)*s
		mov returnValue, eax; //Ulo��me si (s-b)*(s-a)*s do returnValue
		
		//V�po�et s(s-a)(s-b)(s-c)
		mov ebx, c; //Na�teme si c
		mov eax, ecx; //Na�teme si p�vodn� "s"
		sub eax, ebx; //Vypo�teme s-c
		mul returnValue; //Vyn�sob�me (s-c) s hodnotou meziv�sledku (s-b)*(s-a)*s
		mov returnValue, eax; //Ulo��me si kone�n� v�sledek (s-c)*(s-b)*(s-a)*s
	}
	return sqrt(returnValue);
}

int main() {

	//OBDELN�KY

	printf("Obvod obdelnika a=5, b=2: %d\n", obvod_obdelnika(5, 2)); // V�sledek by m�l b�t 14
	printf("Obsah obdelnika a=5, b=2: %d\n", obsah_obdelnika(5, 2)); //V�sledek 10

	//�TVERCE

	printf("Obvod ctverce a=5: %d\n", obvod_ctverce(5)); //V�sledek 20
	printf("Obsah ctverce a=5: %d\n", obsah_ctverce(5)); //V�sledek 25

	//TROJ�HELN�KY -- OBVODY

	printf("Obvod trojuhelnika a=3, b=2, c=4: %d\n", obvod_trojuhelnika(3,2,4)); //Vysledek 9
	printf("Obvod rovnostranneho trojuhelnika a=3: %d\n", obvod_trojuhelnika2(3)); //Vysledek 9

	//TROJ�HELN�KY -- OBSAHY

	printf("Obsahy trojuhelnika a=3, b=2: %d\n", obsah_trojuhelnika2(3,2)); //V�sledek 3
	printf("Obsahy trojuhelnika a=3, va=4: %d\n", obsah_trojuhelnika3(3, 4)); //V�sledek 6

	//KRYCHLE

	printf("Objem krychle a=4: %d\n", objem_krychle(4)); //V�sledek 64

	//HERON�V VZOREC

	printf("Obsah trojuhelniku heronem a=4, b=3, c=3: %f\n", Heron(4, 3, 3)); //V�sledek by mohl b�t cca 4,47

	return 1;
}