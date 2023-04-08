# ARMssembly_1

First we can again create a binary from our assembly code again using:

```
aarch64-linux-gnu-as -o chall_1.o chall_1.S
aarch64-linux-gnu-gcc -static -o chall_1 chall_1.o
qemu-aarch64 ./chall_1 1
You Lose :(
```
Damn...

As we have learned to read AARCH64 assembly in the ARMssembnly_0 challenge we can now test our newly earned knowledge to find the correct command line input.

lines 44 to 54 are highly familiar now, creating a new stackfram, pushing values from `w0` (int argc) and `x1` (char** argv) to the stack, then retreiving argv[1] by dereferencing it's pointer, branching to `atoi` to convert the argument of type sting into an integer and storing the result onto the stack as well. Then the code branches to label `func`.

`func` makes room for anither 32 bytes on the stack, stores the value of `w0` into that new stack space at `sp + 12`. Then it creates three variables with values 87, 3 and 3, and pushes them onto the stack respectively. It then retreives 87 (or 0x57) into `w1` and the value 3 (or 0x3) into `w0`. Then it calls 

```
lsl w0, w1, w0
lsl w0, 87, 3
```

let's look at this in detail:

```
qemu-aarch64 -g 1234 ./chall_1
gdb-multiarch -q ./chall_1
(gdb) target remote :1234
(gdb) break *func
(gdb) continue
(gdb) layout asm
```

Then skip instructions until you reach <func+40> and let's lay the land:

```
(gdb) info registers x0
x0  0x3     3
(gdb) info registers x1
x0  0x57    87
(gdb) info registers sp
sp  0x55007ffd20    0x55007ffd20
x/8x $sp
0x55007ffd20:   0x00000018  0x00000000  0x00000000  0x00000001
0x55007ffd30:   0x00000057  0x00000003  0x00000003  0x00000000
```

Now let's execute the lsl instruction and check our regs and stack again:

```
(gdb) info registers x0
x0  0x2b8     696
(gdb) info registers x1
x0  0x57    87
(gdb) info registers sp
sp  0x55007ffd20    0x55007ffd20
x/8x $sp
0x55007ffd20:   0x00000018  0x00000000  0x00000000  0x00000001
0x55007ffd30:   0x00000057  0x00000003  0x00000003  0x00000000
```

WHat the instruction did is left shifting the value in `w1` (0x57) by the value in `w0` (0x3) and storing the result into `w0` 

```
0x57  = 0000 0000 0101 0111
0x3   = 0000 0000 0000 0011
0x2b8 = 0000 0010 1011 1000
```

Now the resulting value is stored onto the stack as well and into `w1`. Into `w0` we store another 3. We can see this by skipping to <func+56> and running:

```
(gdb) info registers x0
x0  0x3     3
(gdb) info registers x1
x0  0x2b8    696
```

Then it performs the instruction

```
sdiv w0, w1, w0
```
which is a signed divide, and we get:

```
(gdb) info registers x0
x0  0xe8     232
(gdb) info registers x1
x0  0x2b8    696
x/8x $sp
0x55007ffd20:   0x00000018  0x00000000  0x00000000  0x00000001
0x55007ffd30:   0x00000057  0x00000003  0x00000003  0x000002b8
```

We store this new result onto the stack, overwriting the previous result from the left shift operation and loading it into `w1`. Into `w0` we load what we stored at `sp + 12` which is our command line argument.

```
(gdb) info registers x0
x0  0x1     1
(gdb) info registers x1
x0  0xe8    232
x/8x $sp
0x55007ffd20:   0x00000018  0x00000000  0x00000000  0x00000001
0x55007ffd30:   0x00000057  0x00000003  0x00000003  0x000000e8
```

Then after executing the instruction:

```
(gdb) info registers x0
x0  0x1     231
(gdb) info registers x1
x0  0xe8    232
x/8x $sp
0x55007ffd20:   0x00000018  0x00000000  0x00000000  0x00000001
0x55007ffd30:   0x00000057  0x00000003  0x00000003  0x000000e8
```

Then we return from the function. with this final result stored in `w0`. Next we compare the result to 0x0. If the flags register is `not equal` which it is in our case it jumps to `.L4` which calls `puts` on the "You Lose :(" string stored at .LC1. If the result is equal to 0 it in return calls puts on the string "You win !" stored at .LC0. This means that by running the function with input `232`we should get a "You win !". And indeed, by calling 

```
qemu-aarch64 ./chall_1 232
You win!
```
We win. So our flag is 

```
picoCTF{000000e8}
```

And we can write some C code into chall_1.c and compile ot to armv8 to see that our understanding of the code is correct.

```
aarch64-linux-gnu-gcc -S -static -o chall_test.S chall_1.c
```

And indeed we get pretty much the exact same code with some additional labels and changes due to our different gcc version.