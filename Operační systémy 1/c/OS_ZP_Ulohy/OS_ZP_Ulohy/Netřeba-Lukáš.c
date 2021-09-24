#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void int_to_str(char* buf, unsigned int n, unsigned short radix) {
	_asm {
		/*Hlavi�ka funkce, p�i�azov�n� a inicializace*/
		mov edi, buf; //Zji�t�n� adresy z�pisu v�sledku
		movzx ebx, radix; //Na�ten� radixu + neznam. roz���en� na 32b
		mov eax, n; //Na�ten� p�ev�d�n�ho ��sla
		mov ecx, 0; /*Counter, kolikr�t jsme n d�lili radixem, pou�ijeme ho abychom v�d�li kolik hodnot ze z�sobn�ku p�ev�st do bufferu*/
		mov esi, 0; //Posun po bufferu

		/*Vypo��t�me v�echny remaindery*/
	LoopCount: 
		CMP eax, ebx; // if n < radix
		jb EndCount; //jump (if n below radix) to end

		mov edx, 0; //Vynulujeme edx
		div ebx; //eax := n/radix; edx := n%radix

		push edx; //Ulo��me si na z�sobn�k remainder
		inc ecx; //Zv���me counter hodnot remainder�

		jmp LoopCount; //Pokra�ujeme d�le

	EndCount: 
		/*Tady v�me, �e n < radix, tedy n�m chyb�
		p�ev�st je�t� posledn� hodnotu*/
		mov edx, 0; //Vynulujeme edx
		div ebx; //eax := n/radix; edx := n%radix

		push edx; //Ulo��me si na z�sobn�k remainder
		inc ecx; //Zv���me counter hodnot remainder�

		/*Pokra�ujeme p�ev�d�n�m do bufferu*/
	LoopConvert:
		CMP esi, ecx; // iter�tor bufferu < counter rem hodnot na z�sobn�ku
		jae EndConvert;

		pop eax; //Sebereme rem (ve spr�vn�m po�ad� reversed) ze z�sobn�ku
		
		/*Rozd�len� z�pisu 1,2,...9 a A,B,C,...*/
		CMP eax, 10; //if p�eveden� hodnota >= 10
		jae ConvertAbove;

		add eax, 48; /*P�i�teme konstantu k obsahu al 48, kter� n�s posune na odpov�daj�c� char ��slo <0,9>*/
		mov byte ptr [edi + 1 * esi], al; //P�id�me do bufferu p�eveden� ��slo <0,9>

		inc esi; //Zv��en� counter posuvu po bufferu
		jmp LoopConvert; //Opakujeme pro zbyl� ��sla, kdy esi u� je o jedna inkrementovan�

	ConvertAbove:
		add eax, 55; /*P�i�teme k obsahu al konstantu 55, kter� n�s posune na odpov�daj�c� p�smenko, kdy� jsme s obsahem al nad 9*/
		mov byte ptr [edi + 1 * esi], al; /*P�id�me do bufferu p�eveden� ��slo v reprezentaci symbolem <A,T>*/

		inc esi; //Zv��en� counter posuvu po bufferu
		jmp LoopConvert; //Nutno dop�ev�st zbytek

	EndConvert:
		mov byte ptr[edi + 1 * esi], '\0';
	}
}

int pangram(char* sentence) {
	char alphabet[] = "abcdefghijklmnopqrstuvwxyz";
	_asm {
		/*Hlavi�ka funkce, p�i�azov�n� a inicializace*/
		mov edi, sentence; //Zji�t�n� adresy vstupu
		lea ebx, alphabet; //Zji�t�n� adresy lok�ln�ho pomocn�ho pole
		mov ecx, 0; //Counter posuvu po alphabet
		mov esi, 0; //Counter pusuvu po sentence

	ForEachCharInAlphabet:
		CMP ecx, 26; //Dokud jsme nezkusili naj�t v�echna p�smenka z abecedy
		jae EndTrue;

		movzx edx, [ebx + 1 * ecx]; // for char in alphabet

	CheckCharInSentence:
		movzx eax, [edi + 1 * esi]; //Na�teme prvn� char ze sentence
		CMP eax, '\0'; //Pod�v�me se jestli jsme u� na konci �ten� �et�zce
		je EndOfSentence; //Pokud je v sentence aktu�ln� znak '\0' jsme na jeho konci

		CMP eax, 97; //Jestli�e p�smeno v sentence je velk�, konstanta ASCII Table
		jb ConvertToSmall;

		CMP eax, edx; //Jestli�e aktu�ln� p�smenko v sentence se rovn� tomu co hled�me z abecedy
		je LetterFound;

		inc esi;
		jmp CheckCharInSentence; //Hled�me d�l p�smenko ve zbytku sentence

	ConvertToSmall:
		add eax, 32; //Zm�n�me velk� p�smenko na mal�, konstanta ASCII Table
		CMP eax, edx;
		je LetterFound;

		inc esi;
		jmp CheckCharInSentence; //Hled�me d�l p�smenko ve zbytku sentence

	LetterFound:
		inc ecx;
		mov esi, 0; //Pot�ebuje j�t znovu na za��tek v�ty
		jmp ForEachCharInAlphabet; //Hled�me zbytek p�smenek z abecedy v sentence

	EndOfSentence:
		/*Do�li jsme na konec v�ty a jedno z pr�v� proch�zen�ch p�smen abecedy se nenach�zelo v cel� v�t�,
		tud� nemus�me zkou�et dal�� p�smenka abecedy zda ve v�t� tak� jsou*/
		jmp EndFalse; 

	EndFalse:
		mov eax, 0;
		jmp End;

	EndTrue:
		mov eax, 1; //�sp�n� jsme na�li v�echny symboly
		jmp End;

	End:
	}
}

void print_pangrams(char** sentences) {
	char* print_format = "\n%s";
	_asm {
		/*Hlavi�ka funkce, p�i�azov�n� a inicializace*/
		mov edi, sentences; //Adresa pointer� pol�
		mov esi, 0; //Counter skrz sentence in sentences

	LoopThroughSentences:
		mov ebx, [edi + 4 * esi]; //Zjist�me pointer na sentence
		CMP ebx, 0; //Jestli�e tam ��dn� u� nen� kon��me
		je EndLoop;

		inc esi; //Dal�� iterace p�edem

		/*Vol�n� pangramu*/
		push ebx;
		call pangram;
		add esp, 4;

		/*Kdy� je pangram, print*/
		CMP eax, 0;
		ja PrintPangram;

		/*Kdy� nen� ignorujeme a proch�z�me d�l*/
		jmp LoopThroughSentences;

	PrintPangram:
		push ebx;
		push dword ptr[print_format];
		call printf;
		add esp, 8;
		jmp LoopThroughSentences; //Pokra�ov�n� pr�chod�

	EndLoop:
	}
}