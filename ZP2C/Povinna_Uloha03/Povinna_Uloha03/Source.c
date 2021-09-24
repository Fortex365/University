#include <stdio.h>

typedef struct {
	unsigned hours : 5; //32 do toho se na�ich 23h vyjde
	unsigned minutes : 6; //64 do toho se na�ich 59m vejde
	unsigned seconds : 6;
} time;



time Create(int h, int m, int s) {
	time newtime;
	newtime.hours = h;
	newtime.minutes = m;
	newtime.seconds = s;

	return newtime;
}

time(*PTR_Create)(int, int, int) = Create;



time ConvertPrint(time data) {
	int h, m, s;
	h = data.hours;
	m = data.minutes;
	s = data.seconds;

	printf("Bit field to time: %ih%im%is\n", h, m, s);

}

time(*PTR_ConvertPrint)(time) = ConvertPrint;



int main() {
	time midnight = { 23,59,59 };
	printf("Test time: %ih%im%is\n", midnight.hours, midnight.minutes, midnight.seconds);

	//P�evod �asu na bitov� pole
	time noon = (*PTR_Create)(12, 0, 0);
	printf("Time to bit field: %ih%im%is\n", noon.hours, noon.minutes, noon.seconds);

	//P�evod bitov�ho pole na �as
	time test = { 15,11,12 };
	ConvertPrint(test);

	return 0;
}