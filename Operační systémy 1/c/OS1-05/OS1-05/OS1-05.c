#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char* my_strdup(char* s) {
	int n = strlen(s);
	char* string = (char*)malloc(n+1 * sizeof(char)); //Alokace nov�ho pole na vkl�d�n� z kop�rovan�ho
	_asm {
		mov ecx, 0; //Iterace 
		mov ebx, string; //Zapisovac� �et�zec
		mov edx, s; //Po��tek �et�zce z kopie
	For:
		cmp ecx, n;
		jge End;

		mov al, [edx + 1 * ecx]; //Na�teme do eax prvn� char z �et�zce s
		mov[ebx + 1 * ecx], al; //Do kone�n�ho �et�zce zap�eme tento char
		inc ecx; //Counter
		jmp For; //Loop
	End:
		mov[ebx + 1 * ecx], '\0';
	}
	return string;
}

char* abcs(unsigned char n) {
	char* abc = (char*)malloc(sizeof(char) * n + 1);
	_asm {
		mov ecx, 0; //Counter
		movzx edx, n; //Limit
		mov ebx, abc; //Adresa pole
		mov al, 'A'; //Prvn� p�smenko abecedy
	For:
		cmp edx, 26; //Kdy� se po n�s cht�lo v�c p�smen ne� je v abec�d� (27)
		jg Error;
		cmp edx, 0; //Kdy� se po n�s cht�lo nula po�et p�smen z abecedy
		jz End;

		cmp ecx, edx; //for(i=0, i<n,i++)
		jge End;

		mov[ebx + 1 * ecx], al; //Vlo��me p�smenko z abecedy
		inc al; //Posuneme na dal�� p�smenko
		inc ecx; //Counter
		jmp For; //Loop
	Error:
		mov[ebx], 'O';
		mov[ebx + 1], 'o';
		mov[ebx + 2], 'p';
		mov[ebx + 3], 's';
		mov[ebx + 4], '.';
		mov[ebx + 5], '\0';
		jmp ErrorEnd;
	End:
		mov[ebx + 1 * ecx], '\0'; //Ukon��me �et�zec
	}
	ErrorEnd:
	return abc;
}

void print_fact(unsigned char n) {
	char s[4] = { '%','d','\n','\0' };
	_asm {
		movzx edi, n; //Limit
		cmp edi, 0;
		jz ZeroFact;
	Fact:
		movzx ecx, n; //Meziv�sledek
		movzx ebx, n; //Argument pro fact-1
		dec ebx;

		push ecx; //Ulo�en� meziv�sledku
		push ebx; //Vlo�en� argumentu
		call print_fact;
		add esp, 4; //Offset za prvn� argument
		pop ecx; //Vr�cen� meziv�sledku
		imul ecx, eax; //Vyn�soben� m�ziv�sledku s fact(n-1)
		cmp eax, 1; //Jesli�e returnvalue u� byla jedni�ka
		jmp Print; //M��eme rovnou tisknout 
	Print:
		lea esi, s; //Pot�ebujeme form�tovac� �et�zec
		mov ebx, ecx; //V�sledek fact ulo��me do ebx
		push ebx; //D�me druh� argument
		push esi; //D�me tomu prvn� argument
		call printf;
		add esp, 8;

	ZeroFact:
		mov eax, 1;
	End:
	}
}

int main() {
	char* s = "Ahoj";
	char* out = my_strdup(s); 
	printf("%s\n", out);
	printf("%s\n", abcs(27));

	print_fact(3);
}