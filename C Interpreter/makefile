all:Hw2_1 Hw2_2 Hw2_3

Hw2_1:myInterp.g
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myInterp.g
Hw2_2:myInterpLexer.java myInterpParser.java myInterp_test.java
	javac -cp ./antlr-3.5.2-complete.jar:. myInterp_test.java
Hw2_3:myInterpLexer.class myInterpParser.class myInterp_test.class
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test test.c
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test test2.c
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test test3.c
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test test4.c
clean:
	rm -f *.class *tokens
	rm myInterpLexer.java
	rm myInterpParser.java
