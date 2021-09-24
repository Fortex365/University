#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#define myConst 5

void swap(int* a, int* b) {
	_asm {
		mov eax, dword ptr[a]; //Hodnota a
		mov ebx, dword ptr[b]; //Hodnota b

		mov dword ptr[a], ebx; //Na ukazatel a dáme hodnotu b
		mov dword ptr[b], eax; //Na ukazatel b dáme hodnotu a
	}
}

void nasobky(short n) {
	int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
	_asm {
		movsx ecx, n; //Hodnota pro násobení
		lea ebx, arr; //Zjištìní adresy lokálního pole

		//Délka pole, poèet iterací skrz pole
		mov esi, 0;
	For:
		mov eax, [ebx + 4 * esi]; //Do eax první hodnotu pole (první iterace)
		imul ecx; //Eax (aktuálnì iterovaná hodnota pole)*n
		mov[ebx + 4 * esi], eax;
		inc esi;
		cmp esi, 10;
		jl For;
	}
}

void countdown() {
	int countdown[10] = { 0,0,0,0,0,0,0,0,0,0 };
	_asm {
		lea ebx, countdown; //Naètení adresy lokálního pole

		mov edi, 10; //Èíslo poèátku odpoètu
		mov esi, 0; //Counter loopu
	For:
		mov[ebx + 4 * esi], edi; //Do prvního prvku pole dáme 10tku (první iterace)
		dec edi; //Sníení èísla countdownu
		inc esi; //Iteraèní promìnná ++
		cmp esi, 10;
		jl For;
		mov eax, 1; //Jako úspìšnı return value, kdy u je ta fce void
	}
}

void mocniny() {
	short mocniny[10] = { 1,2,3,4,5,6,7,8,9,10 };
	_asm {
		lea ebx, mocniny; //Naètení adresy lokálního pole

		mov esi, 0; //Counter loopu
	For:
		mov eax, [ebx + 2 * esi];
		imul[ebx + 2 * esi];
		mov[ebx + 2 * esi], eax;
		inc esi;
		cmp esi, 10;
		jl For;
	}
}

void mocniny2() {
	int* pole = (int*)malloc(10 * sizeof(int));
	//Není kontrola jestli se povedlo alokovat pamì
	_asm {
		mov ebx, pole; //Adresa lokalního pole
		mov [ebx], 1; //První prvek pole je 1 (2^0 = 1)
		mov esi, 1; //Counter, zaèínáme u na 1. indexu pole (druhı prvek pole)
		mov edi, 2; //Poè. hodnota dle 1. indexu pole je 2 (druhı prvek pole)
	Mocnina:
		cmp esi, 10; //Jestlie je count 10 skonèíme
		jge End;
	 
		mov[ebx + 4 * esi], edi; //Jinak na index pole dáme edx
	
		inc esi; //Zvetšíme counter
		add edi, edi; //Zvìtšíme hodnotu (mocniny)
		jmp Mocnina; //Pokraèujeme dále
	End:
	}
	free(pole);
}

int avg(unsigned int n) {
	short* pole = (short*)malloc(myConst * sizeof(short));
	int result = 0;
	//Není kontrola jestli se povedlo alokovat pamì
	pole[0] = 1;
	pole[1] = 2;
	pole[2] = -2;
	pole[3] = 3;
	pole[4] = 3;
	_asm {
		mov ebx, pole; //Adresa pole
		mov edi, n; //Poèet èísel z pole na jejich prùmìr
		mov esi, 0; //Counter prùchodu polem
		mov eax, 0; //Poèátek sèítání

		cmp edi, 0; //Odchycení dìlení nulou (neprovede se nic)
		jz Error;
	Summing:
		cmp esi, edi;
		jge end;

		movsx ecx, [ebx + 2 * esi]; //Naètení prvku z pole
		add eax, ecx; //Sèítání tìchto èísel
		inc esi; //Další iterace
		jmp Summing;
	End:
		cdq;
		idiv edi;
	Error:
		mov result, eax;
	}
	free(pole);
	return result;
}

int minimum() {
	int min[10] = { 10,9,8,7,-1,5,4,3,2,2 };
	_asm {
		lea ebx, min; //Naètení adresy pole
		mov esi, 1; //První prvek pole se kterım se bude porovnávat je index 1
		mov edi, [ebx]; //První nejmenší prvek
	For:
		cmp esi, 10; //Ukonèující podmínka loopu
		jge End;

		mov eax, [ebx + 4 * esi]; //Porovnání stávajícího minimálního prvku s dalším prvkem v poli
		cmp edi, eax; //Jestlie je naše minimum je vìtší ne právì procházenı prvek v poli
		jg newmin; //Tak skoèíme na návìští, kde vytvoøíme nové minumum
		jmp nonewmin; //Jinak není potøeba nic vytváøet
	newmin:
		mov edi, [ebx + 4 * esi]; //Vytvoøení nového minima z právì prohledávaného prvku pole
		inc esi; //Iteraèní promìnná
		jmp For; //Pokraèujeme loopem
	nonewmin:
		inc esi; //Nic se nemìní na min. hodnotì, iter++ a pokraèujeme loopem
		jmp For;
	End:
		mov eax, edi; //Vısledek v edi hodíme do eax pro konvenci
	}
}

int main() {
	int a = 5;
	int b = 1;

	//Pouívání debuggu pro sledování co se v té pamìti dìje.
	swap(&a,&b);

	nasobky(2);

	countdown();

	mocniny();

	mocniny2();

	avg(4);

	minimum();

	return 1;
}