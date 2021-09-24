#define _CRT_SECURE_NO_WARNINGS //KVÙLI FUNKCI PRINTF


//IMPORTOVÁNÍ KNIHOVEN

#include <stdlib.h>
#include <stdio.h>
#include <math.h>


//OBDELNÍKY

int obvod_obdelnika(int a, int b) {
	_asm {
		mov eax, a; //Naèteme hodnotu strany a
		add eax, b; //Pøidáme hodnotu strany b ke stranì a
		shl eax, 1; //Vynásobíme dvìma
	}
}

int obsah_obdelnika(int a, int b) {
	_asm {
		mov eax, a; //Naèteme hodnotu strany a, do eax
		mul b; //Vynásobíme eax hodnotou b
	}
}


//ÈTVERCE

int obvod_ctverce(int a) {
	_asm {
		mov eax, a; //Naèteme hodnotu strany a
		shl eax, 2; //Vynásobíme ji 4mi 
	}
}

int obsah_ctverce(int a) {
	_asm {
		mov eax, a; //Naèteme hodnotu strany a
		mul a; //Vynásobíme sebou samím
	}
}


//TROJÚHELNÍKY -- OBVODY

int obvod_trojuhelnika(int a, int b, int c) {
	_asm {
		mov eax, a; //Naèteme a
		add eax, b; //Pøièteme k mezivýsledku stranu b
		add eax, c; //Pøièteme k mezivýsledku stranu c
	}
}

int obvod_trojuhelnika2(int a) {
	_asm {
		mov eax, a; //Naèteme a
		add eax, a; //Pøièteme k mezivýsledku podruhé stranu a
		add eax, a; //Pøièteme k mezivýsledku potøetí stranu a
	}
}


//TROJÚHELNÍKY -- OBSAHY

int obsah_trojuhelnika2(int a, int b) {
	_asm {
		mov eax, a; //Naèteme a
		mul b; //Vynásobíme mezivýsledek (eax) s hodnotou b
		shr eax, 1; //Mezivýsledek vydìlíme dvìma
	}
}

int obsah_trojuhelnika3(int a, int va) {
	_asm {
		mov eax, a; //Naèteme a
		mul va; //Vynásobíme mezivýsledek hodnout výšky strany a
		shr eax, 1; //Vydìlíme mezivýsledek dvìma
	}
}


//KRYCHLE

int objem_krychle(int a) {
	_asm {
		mov eax, a; //Naèteme a
		mul a; //Mezivýsledek vynásobíme sebou samím
		mul a; //Mezivýsledek vynásobíme sebou samím
	}
}


//HERONÙV VZOREC

double Heron(int a, int b, int c) {
	int returnValue = 0;
	//int s = 0;
	_asm {
		//VÝPOÈET PARAMETRU S
		mov eax, a; //Naèteme hodnotu a
		add eax, b; //Pøièteme k mezivýsledku b
		add eax, c; //Pøièteme k mezivýsledku c
		shr eax, 1; //Mezivýsledek vydìlíme dvìma
		mov ecx, eax; //Uložení výsledku s do ecx
		
		//Výpoèet s(s-a)
		mov ebx, a; //Naèteme a
		sub eax, ebx; //Vypoèteme s-a 
		mov edx, ecx; //Do edx, hodnotu "s"
		mul edx; //Vypoèteme (s-a)*s
		mov returnValue, eax; //Do returnValue si uložíme mezivýsledek (s-a)*s

		//Výpoèet s(s-a)(s-b)
		mov ebx, b; //Naèteme b
		mov eax, ecx; //Naèteme si pùvodní "s"
		sub eax, ebx; //Vypoèteme s-b
		mul returnValue; //Vynásobíme (s-b) s hodnotou mezivýsledku (s-a)*s
		mov returnValue, eax; //Uložíme si (s-b)*(s-a)*s do returnValue
		
		//Výpoèet s(s-a)(s-b)(s-c)
		mov ebx, c; //Naèteme si c
		mov eax, ecx; //Naèteme si pùvodní "s"
		sub eax, ebx; //Vypoèteme s-c
		mul returnValue; //Vynásobíme (s-c) s hodnotou mezivýsledku (s-b)*(s-a)*s
		mov returnValue, eax; //Uložíme si koneèný vžsledek (s-c)*(s-b)*(s-a)*s
	}
	return sqrt(returnValue);
}

int main() {

	//OBDELNÍKY

	printf("Obvod obdelnika a=5, b=2: %d\n", obvod_obdelnika(5, 2)); // Výsledek by mìl být 14
	printf("Obsah obdelnika a=5, b=2: %d\n", obsah_obdelnika(5, 2)); //Výsledek 10

	//ÈTVERCE

	printf("Obvod ctverce a=5: %d\n", obvod_ctverce(5)); //Výsledek 20
	printf("Obsah ctverce a=5: %d\n", obsah_ctverce(5)); //Výsledek 25

	//TROJÚHELNÍKY -- OBVODY

	printf("Obvod trojuhelnika a=3, b=2, c=4: %d\n", obvod_trojuhelnika(3,2,4)); //Vysledek 9
	printf("Obvod rovnostranneho trojuhelnika a=3: %d\n", obvod_trojuhelnika2(3)); //Vysledek 9

	//TROJÚHELNÍKY -- OBSAHY

	printf("Obsahy trojuhelnika a=3, b=2: %d\n", obsah_trojuhelnika2(3,2)); //Výsledek 3
	printf("Obsahy trojuhelnika a=3, va=4: %d\n", obsah_trojuhelnika3(3, 4)); //Výsledek 6

	//KRYCHLE

	printf("Objem krychle a=4: %d\n", objem_krychle(4)); //Výsledek 64

	//HERONÙV VZOREC

	printf("Obsah trojuhelniku heronem a=4, b=3, c=3: %f\n", Heron(4, 3, 3)); //Výsledek by mohl být cca 4,47

	return 1;
}