# ARMssembly 2

As in ARMssebly 1 nothing new in the beginning, we read a command line argument and run it through `atoi`. Then we call `func1`. There we clear 32 bytes of stack space and push our command line argument to the stack. We can check our current state as usual:

```
aarch64-linux-gnu-as -o chall_2.o chall_2.S
aarch64-linux-gnu-gcc -static -o chall_2 chall_2.o
qemu-aarch64 -g 1234 ./chall_2 3
gdb-multiarch -q ./chall_2
(gdb) target remote 1234
(gdb) break *func1
(gdb) continue
(gdb) layout asm
(gdb) nexti
(gdb) info registers x0
x0    0xdeb26bc2  3736234946
(gdb) info registers x1
x1    0x0  0
(gdb) info registers sp
sp    0x55007ffd30  0x55007ffd30
(gdb) info registers cpsr
cpsr    0x60000000  1610612736
(gdb) x/16x $sp
0x55007ffd30:   0x00000018  0x00000000  0x00000000  0x00000000
0x55007ffd40:   0x007ffd40  0x00000055  0x0040073c  0x00000000
0x55007ffd50:   0x007ffd70  0x00000055  0x00400804  0x00000000
0x55007ffd60:   0x007fff28  0x00000055  0x004007cc  0x00000002
(gdb) nexti
(gdb) nexti
(gdb) nexti
```
What we executed here were the three instructions 

```
str w0,  [sp, #12]
str wzr, [sp, #24]
str wzr, [sp, #28]
```

So we store our `argv[1]` onto the stack and also overwrite what was stored at `sp +24` and `sp + 28` with zero. This space on the stack was previously storing the return address of the atoi call, i.e. the address if the <func1> call.

```
(gdb) info registers x0
x0    0xdeb26bc2  3736234946
(gdb) info registers x1
x1    0x0  0
(gdb) info registers cpsr
cpsr    0x60000000  1610612736
(gdb) x/16x $sp
0x55007ffd30:   0x00000018  0x00000000  0x00000000  0xdeb26bc2
0x55007ffd40:   0x007ffd40  0x00000055  0x00000000  0x00000000
0x55007ffd50:   0x007ffd70  0x00000055  0x00400804  0x00000000
0x55007ffd60:   0x007fff28  0x00000055  0x004007cc  0x00000002 
```

Afterwards we branch to label .L2. From there we load zero into `w1` and argv[1] = 3736234946 into `w0`. now we execute the compare instrcution between 0 and 3736234946. The `cpsr` gets set to 0

```
(gdb) info registers x0
x0    0xdeb26bc2  3736234946
(gdb) info registers x1
x1    0x0  0
(gdb) info registers cpsr
cpsr    0x0  0
```

And then we do 

```
b.cc .L4
```
Which is "branch to .L4 if carry clear". As `cpsr` is completely 0, the carry is clear as well, so we branch.

At .L4 we simply load the values from the two memory locations we initialized with 0 using the `wzr` above, increment one by 3 and the second one by 1 and pushing them back to the stack. 

```
(gdb) info register cpsr
cpsr    0x80000000  -2147483648
(gdb) x/16x $sp
0x55007ffd30:   0x00000018  0x00000000  0x00000000  0xdeb26bc2
0x55007ffd40:   0x007ffd40  0x00000055  0x00000003  0x00000001
0x55007ffd50:   0x007ffd70  0x00000055  0x00400804  0x00000000
0x55007ffd60:   0x007fff28  0x00000055  0x004007cc  0x00000002 
```

after another 10 `nexti`s later we ran through that cycle once more and our stack looks as follows:

```
(gdb) info register cpsr
cpsr    0x80000000  -2147483648
(gdb) x/16x $sp
0x55007ffd30:   0x00000018  0x00000000  0x00000000  0xdeb26bc2
0x55007ffd40:   0x007ffd40  0x00000055  0x00000006  0x00000002
0x55007ffd50:   0x007ffd70  0x00000055  0x00400804  0x00000000
0x55007ffd60:   0x007fff28  0x00000055  0x004007cc  0x00000002 
```

So we always increment the values and compare the one that's incremented by 1 to our command line argument.

```
(gdb) info register cpsr
cpsr    0x60000000  1610612736
(gdb) x/16x $sp
0x55007ffd30:   0x00000018  0x00000000  0x00000000  0xdeb26bc2
0x55007ffd40:   0x007ffd40  0x00000055  0x00000009  0x00000003
0x55007ffd50:   0x007ffd70  0x00000055  0x00400804  0x00000000
0x55007ffd60:   0x007fff28  0x00000055  0x004007cc  0x00000002 
```

now the branch will not execute, as we have seen 0x60000000 translates to 

```
N = 0
Z = 1
C = 1
V = 0
```

Which means the carry is set, so it is not clear. So next we load the value that has been continuously incremented by 3 into `w0` and return from <func1> to <main>.  There it passes into the normal <printf> call and is printed. So the value that is printed will always be 3 times the input value. So the printed value in the case requested by the challenge it will be 

```
3736234946 * 3 = 11208704838
```

However this value is larger than `2**32` but as it is an integer we need to take the result mod `2**32` so the actual result

```
(3736234946 * 3) % 2**32 = 2618770246 = 9c174346
```

So the flag is:

```
picoCTF{9c174346}
```

We can again try to guess the underlying C program in chall_2.c and compile it to assembly in chall_test.S using

```
aarch64-linux-gnu-gcc -S -static -o chall_test.S chall_2.c
```

We can see that we aproximately get what we saw in the challenge, however the `b.cc` instruction is replaced by a `b.lt` instruction.