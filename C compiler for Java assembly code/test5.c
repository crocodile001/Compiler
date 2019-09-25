void main()
{
	int a;

	printf("Please enter one INT: \n");
	scanf("%d", &a);

	if(a>0){
		printf("in_1\n");
		if(a>5){
			printf("in_2\n");
			if(a>10)
				printf("in_3\n");
			else
				printf("out_3\n");
		}
		else{
			printf("out_2\n");
		}
		printf("out_1\n");
	}
	else
		printf("out_0\n");		

	while(a>0){
		if(a>10){
			a = a - 5;
			printf("bigger\n");
		}
		else{
			a = a - 2;
			printf("smaller\n");
		}
	}

	for(a = 10; a >= 1; a--){
		if(a%2==1)
			printf("%d is odd\n", a);
		else
			printf("%d is even\n", a);
	}

	return 0;

	/*	test case

		input =>

			16

		output =>

			in_1
			in_2
			in_3
			out_1
			bigger
			bigger
			smaller
			smaller
			smaller
			10 is even
			9 is odd
			8 is even
			7 is odd
			6 is even
			5 is odd
			4 is even
			3 is odd
			2 is even
			1 is odd

	*/
}
