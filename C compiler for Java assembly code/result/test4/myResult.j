;.source
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 16
.limit locals 16
ldc 0
istore 1
ldc 0
istore 2
ldc 0.0
fstore 5
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "Please enter one INT and one FLOAT: \n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
new java/util/Scanner
dup
getstatic java/lang/System/in Ljava/io/InputStream;
invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
invokevirtual java/util/Scanner/nextInt()I
istore 0
new java/util/Scanner
dup
getstatic java/lang/System/in Ljava/io/InputStream;
invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
invokevirtual java/util/Scanner/nextFloat()F
fstore 4
ldc 0
istore 3
Loop0:
iload 3
iload 0
if_icmpge ELSE0
iload 3
iload 1
swap
iadd
istore 1
ldc 2.5
fload 5
swap
fsub
fstore 5
iload 3
ldc 1
iadd
istore 3
goto Loop0
ELSE0:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "FOR: i = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 3
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
Loop1:
iload 3
ldc 0
if_icmple ELSE1
ldc 2.0
fload 4
swap
fmul
fstore 4
iload 3
ldc 1
isub
istore 3
goto Loop1
ELSE1:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "WHILE: i = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 3
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
Loop2:
iload 3
ldc 1
iadd
istore 3
iload 2
iload 3
iadd
istore 2
iload 3
iload 0
if_icmpgt ELSE2
goto Loop2
ELSE2:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "DO WHILE: i = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 3
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "r = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\nrr = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 2
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\nfr = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
fload 5
invokevirtual java/io/PrintStream/print(F)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "a = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\nb = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
fload 4
invokevirtual java/io/PrintStream/print(F)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
return
.end method
