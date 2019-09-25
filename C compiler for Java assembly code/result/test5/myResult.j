;.source
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 11
.limit locals 11
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "Please enter one INT: \n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
new java/util/Scanner
dup
getstatic java/lang/System/in Ljava/io/InputStream;
invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
invokevirtual java/util/Scanner/nextInt()I
istore 0
iload 0
ldc 0
if_icmple ELSE0
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "in_1\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
iload 0
ldc 5
if_icmple ELSE1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "in_2\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
iload 0
ldc 10
if_icmple ELSE2
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "in_3\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END2
ELSE2:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "out_3\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END2:
goto END1
ELSE1:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "out_2\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END1:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "out_1\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE0:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "out_0\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END0:
Loop0:
iload 0
ldc 0
if_icmple ELSE3
iload 0
ldc 10
if_icmple ELSE4
iload 0
ldc 5
isub
istore 0
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "bigger\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END3
ELSE4:
iload 0
ldc 2
isub
istore 0
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "smaller\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END3:
goto Loop0
ELSE3:
ldc 10
istore 0
Loop1:
iload 0
ldc 1
if_icmplt ELSE5
iload 0
ldc 2
irem
ldc 1
if_icmpne ELSE6
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc ""
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc " is odd\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END4
ELSE6:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc ""
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc " is even\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END4:
iload 0
ldc 1
isub
istore 0
goto Loop1
ELSE5:
ldc 0
return
.end method
