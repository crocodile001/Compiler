#include <stdio.h>
#include <stdlib.h>

void main(){

	int num = 10, num2 = 2;
	float fnum = 15.0, fnum2 = 2.0;
	float s;
	double dnum = 1.5;

	printf("Please enter two number: \n");
 	scanf("%d%f%lf", &num, &fnum, &dnum);


	num <<= num2;
	printf("%d\n", num);
	num >>= num2;
	printf("%d\n", num);
	num |= 4;
	printf("%d\n", num);
	num ^= 4;
	printf("%d\n", num);
	num &= 4;
	printf("%d\n", num);	
	num++;
	printf("%d\n", num);	
	num--;
	printf("%d\n", num);	
	++num;
	printf("%d\n", num);	
	--num;
	printf("%d\n", num);

	if(num2 == 2){
		if(num2 == 3){
			num = 3;	
		}
		else{
			num = 4;
		}
		printf("if\n");
	}
	else{
		printf("else\n");
	}

	fnum2 > 1.0 ? fnum2 = 3.0 : fnum2 = 4.0;
	printf("%f\n", fnum2);
	fnum2 < 1.0 ? fnum2 = 3.0 : fnum2 = 4.0;
	printf("%f\n", fnum2);

	printf("num = %d, num2 = %d\nfnum = %f, fnum2 = %f\n", num, num2, fnum, fnum2);
	printf("%d %d %d\n", sizeof(num), sizeof(fnum), sizeof(double));
	printf("%d %d\n", num++, num);
	printf("%d %d\n", ++num, num);
	printf("%d %d\n", -num, 10+3-1);
	printf("%d %f\n", ~num, fnum+12);
	
	printf("%lf\n", dnum+fnum+6);
	if( dnum > 2 ){
		printf("bigger\n");
	}

}
