#include <stdio.h>
#include <stdlib.h>

void main(){

	int num = 10, num2 = 2, num3 = 5;
	float fnum = 15.0, fnum2 = 2.0;
	float s;

	printf("Please enter two number: \n");
 	scanf("%d%f", &num, &fnum);

 	if (num == 10 && fnum != 10.0){
 		s = (num + 3.14) * fnum2;
		s += fnum;
		printf("In 1\n");
	}
	else if(num <= 15 || fnum >= 10.0){
		s = num * 3.14 + 5;
		s -= fnum;
		printf("In 2\n");
	}
	else if(num > 20 && fnum < 15.0){
		s = num / ( num - fnum );
		s *= fnum2;
		printf("In 3\n");
	}
 	else{
 		s = num * (num - 3.14);
		s /= fnum;
		printf("In 4\n");
 	}

 	printf("The result is %f, num = %d, fnum = %f\n", s, num, fnum);
	printf("num = %d, num2 = %d, num3 = %d\nfnum = %f, fnum2 = %f\n", num, num2, num3, fnum, fnum2);
}

