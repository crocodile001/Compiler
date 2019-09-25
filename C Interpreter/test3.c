#include <stdio.h>
#include <stdlib.h>

void main(){

	int num, num2;
	float fnum, fnum2;

	printf("Please enter four number( two INT + two FLOAT ): \n");
 	scanf("%d%d%f%f", &num, &num2, &fnum, &fnum2);

	switch(num-2){
		case 1:
			num = num | num2;
			fnum += num;
			printf("In 1\n");
			break;
		case 2:
			num = num & num2;
			fnum -= num;
			printf("In 2\n");
			break;
		case 3:
			num = num ^ num2;
			printf("In 3\n");
			break;
		case 4:
			num = num >> num2;
			fnum *= num;
			printf("In 4\n");
			break;
		case 5:
			num = num << num2;
			fnum /= num;
			printf("In 5\n");
			break;
		default:
			num %= num2;
			fnum++;
			fnum2--;
			printf("In 6\n");
			break;
	}

	printf("The result is num = %d, fnum = %f\n", num, fnum);
	printf("num = %d, num2 = %d\nfnum = %f, fnum2 = %f\n", num, num2, fnum, fnum2);

}
