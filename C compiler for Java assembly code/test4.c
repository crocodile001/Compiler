#include <stdio.h>
#include <stdlib.h>

void main(){

	int a, r = 0, rr = 0, i;
	float b, fr = 0.0;

	printf("Please enter one INT and one FLOAT: \n");
 	scanf("%d%f", &a, &b);

	for(i = 0; i < a; i++){
		r += i;
		fr -= 2.5;
	}
	printf("FOR: i = %d\n", i);

	while(i>0){
		b *= 2.0;
		i--;
	}
	printf("WHILE: i = %d\n", i);

	do{
		i++;
		rr = rr + i;
	}while(i<=a);
	printf("DO WHILE: i = %d\n", i);

	printf("r = %d\nrr = %d\nfr = %f\n", r, rr, fr);
	printf("a = %d\nb = %f\n", a, b);

	/*	test case

		input => 

			10 
			2.0

		output =>

			FOR: i = 10
			WHILE: i = 0
			DO WHILE: i = 11
			r = 45
			rr = 66
			fr = -25.0
			a = 10
			b = 2048.0

	*/
}
