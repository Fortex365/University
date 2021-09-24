#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char* my_strdup(char* s) {
	int n = strlen(s);
	char* string = (char*)malloc(n+1 * sizeof(char)); //Alokace nového pole na vkládání z kopírovaného
	_asm {
		mov ecx, 0; //Iterace 
		mov ebx, string; //Zapisovací øetìzec
		mov edx, s; //Poèátek øetìzce z kopie
	For:
		cmp ecx, n;
		jge End;

		mov al, [edx + 1 * ecx]; //Naèteme do eax první char z øetìzce s
		mov[ebx + 1 * ecx], al; //Do koneèného øetìzce zapíšeme tento char
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
		mov al, 'A'; //První písmenko abecedy
	For:
		cmp edx, 26; //Když se po nás chtìlo víc písmen než je v abecìdì (27)
		jg Error;
		cmp edx, 0; //Když se po nás chtìlo nula poèet písmen z abecedy
		jz End;

		cmp ecx, edx; //for(i=0, i<n,i++)
		jge End;

		mov[ebx + 1 * ecx], al; //Vložíme písmenko z abecedy
		inc al; //Posuneme na další písmenko
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
		mov[ebx + 1 * ecx], '\0'; //Ukonèíme øetìzec
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
		movzx ecx, n; //Mezivýsledek
		movzx ebx, n; //Argument pro fact-1
		dec ebx;

		push ecx; //Uložení mezivýsledku
		push ebx; //Vložení argumentu
		call print_fact;
		add esp, 4; //Offset za první argument
		pop ecx; //Vrácení mezivýsledku
		imul ecx, eax; //Vynásobení mézivýsledku s fact(n-1)
		cmp eax, 1; //Jesliže returnvalue už byla jednièka
		jmp Print; //Mùžeme rovnou tisknout 
	Print:
		lea esi, s; //Potøebujeme formátovací øetìzec
		mov ebx, ecx; //Výsledek fact uložíme do ebx
		push ebx; //Dáme druhý argument
		push esi; //Dáme tomu první argument
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