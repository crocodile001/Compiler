void main()
{
	double a = 12.0d, b = 2.3d, c = 2.6d;
	float d = 1.0, e = 2.0;
	int g = 1, h = 2;
	float f;
	int i;

	a = 5.0d;
	printf("%lf\n", a);		// 5.0
	a += 1.25d;
	a = a + 1.25d;
	printf("%lf\n", a);		// 7.5
	a -= 1.75d;
	a = a - 1.75d;
	printf("%lf\n", a);		// 4.0
	a *= 2.1d;
	a = a * 1.0d;
	printf("%lf\n", a);		// 8.4
	a = a / 4.2d;
	printf("%lf\n", a);		// 2.0
	a = a % 1.5d;
	printf("%lf\n", a);		// 0.5

	a++;
	printf("%lf\n", a);			// 1.5
	a--;
	printf("%lf\n", a);			// 0.5
	++a;
	printf("%lf\n", a);			// 1.5
	--a;
	printf("%lf\n", a);			// 0.5
	a = -a;
	printf("%lf\n", a);			// -0.5

	a = 0.0d;
	for(i = 0; i < 10; i++){
		a += 1.0d;
	}
	printf("FOR: i = %d, a = %lf\n", i, a);

	a = 0.0d;
	while(i>0){
		a += 2.0d;
		i--;
	}
	printf("WHILE: i = %d, a = %lf\n", i, a);

	if(a>0.0d){
		printf("in_1\n");
		if(a>=5.0d){
			printf("in_2\n");
			if(a<10.0d)
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

	f = 3.0;
	a = ( b + 1.0d ) * c;
	printf("a = %lf\n", a);		// 8.58
	a = b + 1.5d * c;
	printf("a = %lf\n", a);		// 6.2

	scanf("%lf", &a);
	
	printf("a = %lf, b = %lf, c = %lf\n", a, b, c);
	printf("d = %f, e = %f, f = %f\n", d, e, f);
	printf("g = %d, h = %d, i = %d\n", g, h, i);

	/*	test case

		input =>

			16

		output =>

			5.0
			7.5
			4.0
			8.399999618530273
			2.0
			0.5
			1.5
			0.5
			1.5
			0.5
			-0.5
			FOR: i = 10, a = 10.0
			WHILE: i = 0, a = 20.0
			in_1
			in_2
			out_3
			out_1
			a = 8.579999561309819
			a = 6.199999809265137
			a = 16, b = 2.299999952316284, c = 2.5999999046325684
			d = 1.0, e = 2.0, f = 3.0
			g = 1, h = 2, i = 0

	*/

}
