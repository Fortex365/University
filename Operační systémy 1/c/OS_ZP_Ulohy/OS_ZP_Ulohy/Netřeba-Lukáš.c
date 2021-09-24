#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void int_to_str(char* buf, unsigned int n, unsigned short radix) {
	_asm {
		/*Hlavièka funkce, pøiøazování a inicializace*/
		mov edi, buf; //Zjištìní adresy zápisu výsledku
		movzx ebx, radix; //Naètení radixu + neznam. rozšíøení na 32b
		mov eax, n; //Naètení pøevádìného èísla
		mov ecx, 0; /*Counter, kolikrát jsme n dìlili radixem, použijeme ho abychom vìdìli kolik hodnot ze zásobníku pøevést do bufferu*/
		mov esi, 0; //Posun po bufferu

		/*Vypoèítáme všechny remaindery*/
	LoopCount: 
		CMP eax, ebx; // if n < radix
		jb EndCount; //jump (if n below radix) to end

		mov edx, 0; //Vynulujeme edx
		div ebx; //eax := n/radix; edx := n%radix

		push edx; //Uložíme si na zásobník remainder
		inc ecx; //Zvýšíme counter hodnot remainderù

		jmp LoopCount; //Pokraèujeme dále

	EndCount: 
		/*Tady víme, že n < radix, tedy nám chybí
		pøevést ještì poslední hodnotu*/
		mov edx, 0; //Vynulujeme edx
		div ebx; //eax := n/radix; edx := n%radix

		push edx; //Uložíme si na zásobník remainder
		inc ecx; //Zvýšíme counter hodnot remainderù

		/*Pokraèujeme pøevádìním do bufferu*/
	LoopConvert:
		CMP esi, ecx; // iterátor bufferu < counter rem hodnot na zásobníku
		jae EndConvert;

		pop eax; //Sebereme rem (ve správném poøadí reversed) ze zásobníku
		
		/*Rozdìlení zápisu 1,2,...9 a A,B,C,...*/
		CMP eax, 10; //if pøevedená hodnota >= 10
		jae ConvertAbove;

		add eax, 48; /*Pøièteme konstantu k obsahu al 48, která nás posune na odpovídající char èíslo <0,9>*/
		mov byte ptr [edi + 1 * esi], al; //Pøidáme do bufferu pøevedené èíslo <0,9>

		inc esi; //Zvýšení counter posuvu po bufferu
		jmp LoopConvert; //Opakujeme pro zbylé èísla, kdy esi už je o jedna inkrementované

	ConvertAbove:
		add eax, 55; /*Pøièteme k obsahu al konstantu 55, která nás posune na odpovídající písmenko, když jsme s obsahem al nad 9*/
		mov byte ptr [edi + 1 * esi], al; /*Pøidáme do bufferu pøevedené èíslo v reprezentaci symbolem <A,T>*/

		inc esi; //Zvýšení counter posuvu po bufferu
		jmp LoopConvert; //Nutno dopøevést zbytek

	EndConvert:
		mov byte ptr[edi + 1 * esi], '\0';
	}
}

int pangram(char* sentence) {
	char alphabet[] = "abcdefghijklmnopqrstuvwxyz";
	_asm {
		/*Hlavièka funkce, pøiøazování a inicializace*/
		mov edi, sentence; //Zjištìní adresy vstupu
		lea ebx, alphabet; //Zjištìní adresy lokálního pomocného pole
		mov ecx, 0; //Counter posuvu po alphabet
		mov esi, 0; //Counter pusuvu po sentence

	ForEachCharInAlphabet:
		CMP ecx, 26; //Dokud jsme nezkusili najít všechna písmenka z abecedy
		jae EndTrue;

		movzx edx, [ebx + 1 * ecx]; // for char in alphabet

	CheckCharInSentence:
		movzx eax, [edi + 1 * esi]; //Naèteme první char ze sentence
		CMP eax, '\0'; //Podíváme se jestli jsme už na konci ètení øetìzce
		je EndOfSentence; //Pokud je v sentence aktuální znak '\0' jsme na jeho konci

		CMP eax, 97; //Jestliže písmeno v sentence je velké, konstanta ASCII Table
		jb ConvertToSmall;

		CMP eax, edx; //Jestliže aktuální písmenko v sentence se rovná tomu co hledáme z abecedy
		je LetterFound;

		inc esi;
		jmp CheckCharInSentence; //Hledáme dál písmenko ve zbytku sentence

	ConvertToSmall:
		add eax, 32; //Zmìníme velké písmenko na malé, konstanta ASCII Table
		CMP eax, edx;
		je LetterFound;

		inc esi;
		jmp CheckCharInSentence; //Hledáme dál písmenko ve zbytku sentence

	LetterFound:
		inc ecx;
		mov esi, 0; //Potøebuje jít znovu na zaèátek vìty
		jmp ForEachCharInAlphabet; //Hledáme zbytek písmenek z abecedy v sentence

	EndOfSentence:
		/*Došli jsme na konec vìty a jedno z právì procházených písmen abecedy se nenacházelo v celé vìtì,
		tudíž nemusíme zkoušet další písmenka abecedy zda ve vìtì také jsou*/
		jmp EndFalse; 

	EndFalse:
		mov eax, 0;
		jmp End;

	EndTrue:
		mov eax, 1; //Úspìšnì jsme našli všechny symboly
		jmp End;

	End:
	}
}

void print_pangrams(char** sentences) {
	char* print_format = "\n%s";
	_asm {
		/*Hlavièka funkce, pøiøazování a inicializace*/
		mov edi, sentences; //Adresa pointerù polí
		mov esi, 0; //Counter skrz sentence in sentences

	LoopThroughSentences:
		mov ebx, [edi + 4 * esi]; //Zjistíme pointer na sentence
		CMP ebx, 0; //Jestliže tam žádný už není konèíme
		je EndLoop;

		inc esi; //Další iterace pøedem

		/*Volání pangramu*/
		push ebx;
		call pangram;
		add esp, 4;

		/*Když je pangram, print*/
		CMP eax, 0;
		ja PrintPangram;

		/*Když není ignorujeme a procházíme dál*/
		jmp LoopThroughSentences;

	PrintPangram:
		push ebx;
		push dword ptr[print_format];
		call printf;
		add esp, 8;
		jmp LoopThroughSentences; //Pokraèování prùchodù

	EndLoop:
	}
}