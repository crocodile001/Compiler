#include <stdio.h>
#include <stdlib.h>

void main(){

	int a, r;
	float b, fr;

	printf("Please enter one INT and one FLOAT: \n");
 	scanf("%d%f", &a, &b);

 	if (a > 50){
 		r = 5 * (a + 3);
		fr = b + 3.0 * 5.0;
		printf("In 1\n");
	}
	else if(b < 5.0){
		r = (a - 5) / 3;
		fr = b - 5.0 / 3.0;
		printf("In 2\n");
	}
	else if(a >= 20){
		r = a % 3;
		fr = b % 3.0;
		printf("In 3\n");
	}
	else if(b <= 10.0){
		r = a % 3;
		fr = b % 3.0;
		printf("In 4\n");
	}
	else if(a == 6){
		r = 7 | 8;
		fr = 6.6;
		printf("In 5\n");
	}
	else if(a != 2){
		r = 11 & 3;
		fr = 2.2;
		printf("In 6\n");
	}
 	else{
 		r = 15 ^ 4;
		fr = 0.0;
		printf("In 7\n");
 	}

 	printf("The result is r = %d, fr = %f\n", r, fr);
	printf("a = %d, b = %f\n", a, b);

	/*	test case

		52 1.0 => 275 16.0
		1 1.0 => -1 -0.666
		32 10.0 => 2 1.0
		10 8.0 => 1 2.0
		6 15.0 => 15 6.6
		4 15.0 => 3 2.2
		2 15.0 => 11 0.0

	*/
}

