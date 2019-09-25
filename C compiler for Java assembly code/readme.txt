
	405410013 資工三 張可雋

	How to compile and execute my lexical analyzer :

		Open the terminal , then type in 'make' command.

		All of the compile's and execute's commands are written in makefile.
		
		每次 make，程式只會產生一個 .j 檔和 一個 .class，所以會覆蓋之前的結果，
		
		如果要執行不同 .c 檔的結果，必須手動更改 makefile 的目標 .c 檔，
		
		最後，只要在有 .class 的資料夾，執行 " java myResult "
		
		( 在 result 資料夾中，有已經編譯過的所有 .j 和 .class )

		Finally , in the terminal , type in 'make clean' to clean all of the unnecessary files.

		
	The features of my compiler :

		---   more detail : written in MS-WORD file   ---
		
		Data Type : int, float, double	( 宣告變數時，變數可以給初始值 )
		
		printf 支援多個變數輸出和多個換行符，scanf 支援多個不同型態變數輸入
		
		除了資料結構之外，程式幾乎實現所有 c 的 Arithmetic Computation、Comparison Expression 和 Control Flow ( 包括多種多層嵌套 )
		
		所有語法皆按照 c 的標準規定，錯誤語法不會通過 parser 的檢查，
		
		例如 : else if 寫在 else 之後、case 寫在 default 之後，或是寫不完整的語法也不會通過檢查，例如 : 只有 else、case 等
		
		“ .limit stack number “ 和 “ .limit locals number ” :
		
			number 是依照程式宣告的變數數量 + 10，由程式動態產生出合適的數值

		所有 test.c 檔案在文件最後都有參考輸入和輸出
		
	
	額外要注意的地方 :
	
		程式中的數字 :
			
			float 給予的數字一定要有小數點，double 給予的數字不但要有小數點，結尾一定要有 d，
			
			例如 : double a = 1.2d; float b = 1.2;
			
			( 為了區分 int, float, double 的差別，同時也減少程式出錯的機率 )
		
		scanf :
		
			輸入時，float 給予的數字可以沒有小數點，
			
			double 給予的數字也可以沒有小數點，且結尾一定不能有 d