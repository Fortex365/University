#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#define myConst 5

void swap(int* a, int* b) {
	_asm {
		mov eax, dword ptr[a]; //Hodnota a
		mov ebx, dword ptr[b]; //Hodnota b

		mov dword ptr[a], ebx; //Na ukazatel a d�me hodnotu b
		mov dword ptr[b], eax; //Na ukazatel b d�me hodnotu a
	}
}

void nasobky(short n) {
	int arr[10] = { 1,2,3,4,5,6,7,8,9,10 };
	_asm {
		movsx ecx, n; //Hodnota pro n�soben�
		lea ebx, arr; //Zji�t�n� adresy lok�ln�ho pole

		//D�lka pole, po�et iterac� skrz pole
		mov esi, 0;
	For:
		mov eax, [ebx + 4 * esi]; //Do eax prvn� hodnotu pole (prvn� iterace)
		imul ecx; //Eax (aktu�ln� iterovan� hodnota pole)*n
		mov[ebx + 4 * esi], eax;
		inc esi;
		cmp esi, 10;
		jl For;
	}
}

void countdown() {
	int countdown[10] = { 0,0,0,0,0,0,0,0,0,0 };
	_asm {
		lea ebx, countdown; //Na�ten� adresy lok�ln�ho pole

		mov edi, 10; //��slo po��tku odpo�tu
		mov esi, 0; //Counter loopu
	For:
		mov[ebx + 4 * esi], edi; //Do prvn�ho prvku pole d�me 10tku (prvn� iterace)
		dec edi; //Sn�en� ��sla countdownu
		inc esi; //Itera�n� prom�nn� ++
		cmp esi, 10;
		jl For;
		mov eax, 1; //Jako �sp�n� return value, kdy� u� je ta fce void
	}
}

void mocniny() {
	short mocniny[10] = { 1,2,3,4,5,6,7,8,9,10 };
	_asm {
		lea ebx, mocniny; //Na�ten� adresy lok�ln�ho pole

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
	//Nen� kontrola jestli se povedlo alokovat pam�
	_asm {
		mov ebx, pole; //Adresa lokaln�ho pole
		mov [ebx], 1; //Prvn� prvek pole je 1 (2^0 = 1)
		mov esi, 1; //Counter, za��n�me u� na 1. indexu pole (druh� prvek pole)
		mov edi, 2; //Po�. hodnota dle 1. indexu pole je 2 (druh� prvek pole)
	Mocnina:
		cmp esi, 10; //Jestli�e je count 10 skon��me
		jge End;
	 
		mov[ebx + 4 * esi], edi; //Jinak na index pole d�me edx
	
		inc esi; //Zvet��me counter
		add edi, edi; //Zv�t��me hodnotu (mocniny)
		jmp Mocnina; //Pokra�ujeme d�le
	End:
	}
	free(pole);
}

int avg(unsigned int n) {
	short* pole = (short*)malloc(myConst * sizeof(short));
	int result = 0;
	//Nen� kontrola jestli se povedlo alokovat pam�
	pole[0] = 1;
	pole[1] = 2;
	pole[2] = -2;
	pole[3] = 3;
	pole[4] = 3;
	_asm {
		mov ebx, pole; //Adresa pole
		mov edi, n; //Po�et ��sel z pole na jejich pr�m�r
		mov esi, 0; //Counter pr�chodu polem
		mov eax, 0; //Po��tek s��t�n�

		cmp edi, 0; //Odchycen� d�len� nulou (neprovede se nic)
		jz Error;
	Summing:
		cmp esi, edi;
		jge end;

		movsx ecx, [ebx + 2 * esi]; //Na�ten� prvku z pole
		add eax, ecx; //S��t�n� t�chto ��sel
		inc esi; //Dal�� iterace
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
		lea ebx, min; //Na�ten� adresy pole
		mov esi, 1; //Prvn� prvek pole se kter�m se bude porovn�vat je index 1
		mov edi, [ebx]; //Prvn� nejmen�� prvek
	For:
		cmp esi, 10; //Ukon�uj�c� podm�nka loopu
		jge End;

		mov eax, [ebx + 4 * esi]; //Porovn�n� st�vaj�c�ho minim�ln�ho prvku s dal��m prvkem v poli
		cmp edi, eax; //Jestli�e je na�e minimum je v�t�� ne� pr�v� proch�zen� prvek v poli
		jg newmin; //Tak sko��me na n�v�t�, kde vytvo��me nov� minumum
		jmp nonewmin; //Jinak nen� pot�eba nic vytv��et
	newmin:
		mov edi, [ebx + 4 * esi]; //Vytvo�en� nov�ho minima z pr�v� prohled�van�ho prvku pole
		inc esi; //Itera�n� prom�nn�
		jmp For; //Pokra�ujeme loopem
	nonewmin:
		inc esi; //Nic se nem�n� na min. hodnot�, iter++ a pokra�ujeme loopem
		jmp For;
	End:
		mov eax, edi; //V�sledek v edi hod�me do eax pro konvenci
	}
}

int main() {
	int a = 5;
	int b = 1;

	//Pou��v�n� debuggu pro sledov�n� co se v t� pam�ti d�je.
	swap(&a,&b);

	nasobky(2);

	countdown();

	mocniny();

	mocniny2();

	avg(4);

	minimum();

	return 1;
}