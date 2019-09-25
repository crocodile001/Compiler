;.source
.class public static myResult
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 14
.limit locals 14
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
fstore 2
iload 0
ldc 50
if_icmple ELSE0
ldc 5
iload 0
ldc 3
iadd
imul
istore 1
fload 2
ldc 3.0
ldc 5.0
fmul
fadd
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 1\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE0:
fload 2
ldc 5.0
fcmpl
ifge ELSE1
iload 0
ldc 5
isub
ldc 3
idiv
istore 1
fload 2
ldc 5.0
ldc 3.0
fdiv
fsub
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 2\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE1:
iload 0
ldc 20
if_icmplt ELSE2
iload 0
ldc 3
irem
istore 1
fload 2
ldc 3.0
frem
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 3\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE2:
fload 2
ldc 10.0
fcmpl
ifgt ELSE3
iload 0
ldc 3
irem
istore 1
fload 2
ldc 3.0
frem
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 4\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE3:
iload 0
ldc 6
if_icmpne ELSE4
ldc 7
ldc 8
ior
istore 1
ldc 6.6
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 5\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE4:
iload 0
ldc 2
if_icmpeq ELSE5
ldc 11
ldc 3
iand
istore 1
ldc 2.2
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 6\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto END0
ELSE5:
ldc 15
ldc 4
ixor
istore 1
ldc 0.0
fstore 3
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "In 7\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
END0:
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "The result is r = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc ", fr = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
fload 3
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
ldc ", b = "
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
fload 2
invokevirtual java/io/PrintStream/print(F)V
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
return
.end method
