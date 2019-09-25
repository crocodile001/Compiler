#include <stdio.h>
#include <stdlib.h>

int main(){
	
	int a = 3, result = 7;
	float b = 2.0, fresult;
	

	fresult = 5.0;
	printf("%f\n", fresult);		// 5.0
	fresult += 2.5;
	printf("%f\n", fresult);		// 7.5
	fresult -= 3.5;
	printf("%f\n", fresult);		// 4.0
	fresult *= 2.1;
	printf("%f\n", fresult);		// 8.4
	fresult /= 4.2;
	printf("%f\n", fresult);		// 2.0
	fresult %= 1.5;
	printf("%f\n", fresult);		// 0.5


	printf("%d <<= 2 =>", result);
	result <<= 2;
	printf(" %d\n", result);		// 28
	printf("%d >>= 2 =>", result);		
	result >>= 2;
	printf(" %d\n", result);		// 7


	printf("%d |= 8 =>", result);
	result |= 8;
	printf(" %d\n", result);		// 15
	printf("%d ^= 4 =>", result);
	result ^= 4;
	printf(" %d\n", result);		// 11
	printf("%d &= 3 =>", result);
	result &= 3;
	printf(" %d\n", result);		// 3


	result++;
	printf("%d\n", result);			// 4
	result--;
	printf("%d\n", result);			// 3
	++result;
	printf("%d\n", result);			// 4
	--result;
	printf("%d\n", result);			// 3
	result = -result;
	printf("%d\n", result);			// -3


	return 0;
}

