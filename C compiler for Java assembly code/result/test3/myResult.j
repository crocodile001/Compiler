;.source
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 12
.limit locals 12
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
ldc 1
iadd
lookupswitch
1: R0
2: R1
9: R2
15: R3
default : R4
R0:
iload 0
ldc 1
iadd
ldc 1
ishl
istore 1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 1\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
R1:
iload 0
ldc 8
imul
ldc 2
ishr
istore 1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 2\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
R2:
iload 0
ldc 7
ior
istore 1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 3\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
R3:
iload 0
ldc 7
iand
istore 1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 4\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
R4:
iload 0
ldc 15
ixor
istore 1
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In default\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END0:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "The result is num = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\na = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
return
.end method
