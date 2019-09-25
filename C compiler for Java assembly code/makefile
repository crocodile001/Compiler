all:Hw2_1 Hw2_2 Hw2_3

Hw2_1:myCompiler.g
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
Hw2_2:myCompilerLexer.java myCompilerParser.java myCompiler_test.java
	javac -cp ./antlr-3.5.2-complete.jar:. myCompiler_test.java
Hw2_3:myCompilerLexer.class myCompilerParser.class myCompiler_test.class
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test.c > myResult.j
	java -jar ./jasmin-2.4/jasmin.jar myResult.j
	#java myResult
	#make clean
clean:
	rm -f *.class *tokens
	rm myCompilerLexer.java
	rm myCompilerParser.java
