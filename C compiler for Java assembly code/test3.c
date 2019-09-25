#include <stdio.h>
#include <stdlib.h>

void main(){

	int a, r;

	printf("Please enter one INT: \n");
 	scanf("%d", &a);

	switch(a+1){
		case 1:
			r = (a+1) << 1;
			printf("In 1\n");
			break;
		case 2:
			r = (a*8) >> 2
			printf("In 2\n");
			break;
		case 9:
			r = a | 7;
			printf("In 3\n");
			break;
		case 15:
			r = a & 7;
			printf("In 4\n");
			break;
		default:
			r = a ^ 15;
			printf("In default\n");
			break;
	}

	printf("The result is num = %d\na = %d\n", r, a);

	/*	test case

		0 => 2
		1 => 2
		8 => 15
		14 => 6
		2 => 13 

	*/
}
