# ARMssembly_0

## The challenge
We get a file called `chall.S` which is an ARMv8 Assembly program.

The solution to the puzzle is the number this program returns with arguments 266134863 and 1592237099? 

The flag will contain this number in format: picoCTF{XXXXXXXX} -> (hex, lowercase, no 0x, and 32 bits. ex. 5614267 would be picoCTF{0055aabb})

## Cross-Compiling ARMv8 assembly on an x86_64 machine

The first intuition would be to just compile and run the program with the required inputs. This is however not a trivial task. As it is ARMv8 assembly it won't run on most normal laptop or desktop machines as they are typically x86 processor architectures. A Raspberry Pi (the ARM chip that might be lying around some peoples houses) it is not certain that this will compile, on my Raspberry Pi 4B the assembler threw an error as i am using the 32-bit version of the OS. One option to run the program is to use `qemu` which (according to it's wikipedia https://en.wikipedia.org/wiki/QEMU) can do user-mode emulation for several processor architectures, including ARMv8. First we need to assemble the source code file into an executable binary. I am using Ubuntu in WSL so to install the software required for compilation i can run:

```
sudo apt install binutils-aarch64-linux-gnu
sudo apt install gcc-aarch64-linux-gnu
```

With these two applications running the source file can be compiled using the following two commands:

```
aarch64-linux-gnu-as -o chall.o chall.S
aarch64-linux-gnu-gcc -static -o chall chall.o
```

The last step is to install the qemu user-mode emulator to run binaries compiled for different platforms using the command:

```
sudo apt install qemu-user
```

This works like a charm if you want to run binaries compiled for a different processor architecture. If we check on our binary we can see that it is ARMv8 or aarch64:

```
$ file chall
chall: ELF 64-bit LSB executable, ARM aarch64, version 1 (GNU/Linux), statically linked, BuildID[sha1]=01f9fa0c8ea99099d48e622391bbf3269ff150e5, for GNU/Linux 3.7.0, not stripped
```

However if we execute the file as we would execute any proper x86 binary we get:

```
$ qemu-aarch64 ./chall
qemu: uncaught target signal 11 (Segmentation fault) - core dumped
Segmentation fault
```

Told you it works like charm... So actually what's wrong is that the program requires two command line arguments or it will crash. We can guess this from the fact that the challenge asks us to say what the program outputs with two given inputs. If we try a couple of combinations, we see that it is working:

```
$ qemu-aarch64 ./chall 0 0
Result: 0
$ qemu-aarch64 ./chall 0 1
Result: 1
$ qemu-aarch64 ./chall 0 12
Result: 12
$ qemu-aarch64 ./chall 1 12
Result: 12
```

We see that the program simply throws back the second command line argument at us, regardless of the first one. With this information we could already complete the challenge, however maybe it is interesting to look at the code to learn something about ARM Assembly. So let's waste some time (i want to get a better understanding of Assembly language so i am only wasting your time, not my own...).

## Diving into the Assembly Code

### General Overview

At first glance we see some stuff that is familiar to anyone who has written some code in C, namely the words `atoi` in lines `40`and `45` and `printf` in line `52`. `atoi` is a function from the C-Standard library that takes a string representation of an integer and returns that integer `atoi("1") = 1`. `printf` takes as inputs a format string and a series of values and prints them to stdout. Both these symbols are preceded by the `bl` instruction which stands for `branch with link`. This is essentially the function call instruction as it will jump to a certain function label and remember where to come back once this function returns.

We see the `bl` instruction appearing once more in the code, this time followed by the label `func1` in line `48`. `func1` is defined above in line `7`, so we can be quite sure that between calling `atoi` twice and the `printf`-call we also call `func1`.

We also have seen above, that the programm takes two command line arguments and simply returns the second one of them. 

Therefor the C code from which the program has been compiled likely looks something like this what we declare in the `test.c` file. And indeed, once we compile this to aarch64 assembly code using 

```
aarch64-linux-gnu-gcc -S -static -o test.S test.c
```

we can see that what we get is quite similar though not identical to what has been given to us in the challenge. We can see that there are a lot more labels added like `.cfi_startproc`. I will ignore these for now as i do not yet understand their function myself, however as they are not present in the original assembly code file and this still runs i assume that they are simply some overhead added by the newer version of the gcc compiler to confuse me as the reader. In the second to last line of `chall.S` we can see that it was compiled using gcc 7.5.0 and i am using gcc 11.3.0 In the `test_stripped.S` file we can see the same code with these labels removed. Let's take the rest of it apart to better understand what's happening.

### How printf on its own works

First let's look at an even simpler program that just takes the first command line argument and without modifying it at all prints it back at us. The respective file is called `test_print.c`. As we do not use `atoi` we will have to change some things. First, the variable `first`, into which we store the first command line argument, needs to be of type string (or pointer to character, which is how you declare a string in C). Second, in the format string of printf we need to replace the `%d` for double with an `%s` for string. Now we can compile and run it, and if it works look at the corresponding assembly code.

```
$ aarch64-linux-gnu-gcc  -static -o test_print test_print.c
$ qemu-aarch64 ./test_print Hello
Result: Hello
$ aarch64-linux-gnu-gcc -S -static -o test_print.S test_print.c
```

Again I will create a stripped version of the assembly file to have a better overview over what happens. We can go throug the `main`-function step by step. The first line is the same accross all the assembly files we have produced so far:

```
stp	x29, x30, [sp, -48]!
```

`stp` stands for store pair and stores the values in the two registers `x29`and `x30` in the processor into the memory location passed as the third argument in the instruction. This third argument means that the stack pointer should be decremented by 48 and the values should be stored at this new address. This is called pre-indexing (https://developer.arm.com/documentation/den0024/a/The-A64-instruction-set/Memory-access-instructions/Specifying-the-address-for-a-Load-or-Store-instruction)

The second line is belongs to the same procedure, namely "pushing a stack frame". Let's try to visualize this. The best way to get detailed information on the inner workings of our program is to use the GNU Debugger `gdb`. To work with AARCH64 binaries we will have to install gdb-multiarch

```
sudo apt install gdb-multiarch
```

Now we can "debug" AARCH64 binaries with this tool the following way. We execute the binary using qemu-aarch64 but with a gdb-flag:

```
qemu-aarch64 -g 1234 ./test_print hi
```

This will look as if the program hangs but essentially it just doesn't execute until you make it do so from within gdb. Now from a separate terminal window we run:

```
gdb-multiarch -q ./test_print
```

which will get us into gdb. First we will need to connect to the qemu session we just started by:

```
(gdb) target remote :1234
```

Next we will set our breakpoint to `main` by doing:

```
(gdb) break *main
```

the asterisk is important or the program will break not where main starts in memory but a couple of instructions later as usually when working with binaries we are not intersted in the first couple of instructions as they are always the same. but we want to go step by step so we need the asterisk.

Now we can display the assembly code of our program:

```
(gdb) layout asm
```

your screen should look somthing like this now:

(include screenshot here)

now we hit 

```
(gdb) continue
```

which will run us to the breakpoint we set for our program. We can now see the program's assembly code layed out as follows:

![](./images/snapshot_main.png)

We can retreive information about the values stored in our registers using the `info registers <register_number>` command. registers of interest to us are `x0`, `x1`, `x29`, `x30` and `sp`. The current state of these registers is:

```
(gdb) info registers x0
x0  0x2
(gdb) info registers x1
x1  0x55007fff38
(gdb) info registers x29
x29 0x55007ffd80
(gdb) info registers x30
x30 0x4007b4
(gdb) info registers sp
sp  0x55007ffd80
```
We see that x0 holds the number 2 which is argc, the number of command line arguments at function call (`[./test_print, hi]` in python list synthax). `x1` holds a memory address, the contents of which we can examine using

```
(gdb) x/2x 0x55007fff38
0x55007fff38:   0x0080019a  0x00000055
```

`x` in this case stands for examine and the `/2x` allows you to extract two times 4 bytes in hexadecimal notation. What we see here is, drum roll, another memory address in weird reverse ordering, namely the address of the first argument of our argv list: `0x550080019a`. Remember how you specifiy argv in your C-code: 

```
int main(int argc, char **argv){...}
``` 

argv is an 8-byte pointer to an 8-byte pointer pointing to the first command line argument. If we want to access the second command line argument (our "hi") we have to look at the next 8 bytes in memory 

```
(gdb) x/2x 0x55007fff40
0x55007fff40:   0x008001a7  0x00000055
```

which translates to the address of our second command line argument `0x55008001a7`. We can verify this by dereferencing these two addresses. What we expect is a hexadecimal representation of our two command line arguments, namely:
```
.    /    t    e    s    t    _    p    r    i    n    t
0x2E 0x2F 0x74 0x65 0x73 0x74 0x5F 0x70 0x72 0x69 0x6E 0x74
h    i
0x68 0x69
```

Let's see if we can find these. For the first argument we expect 12(= 3 x 4) bytes, so we do

```
(gdb) x/3x 0x550080019a
0x550080019a:   0x65742f2e  0x705f7473  0x746e6972
```

which indeed is what we expect, though in weird 32-bit, reverse order chunks. For the second argument we expect 2 bytes, so we simply do

```
(gdb) x/x 0x55008001a7
0x55008001a7:   0x5f006968
```

Which is also what we expect. Now we know everything we need to know before starting to execute our program.

With the command 

```
(gdb) nexti
```

we can execute the first instruction and jump to the next one. Let's look at our registers again:

```
(gdb) info registers x0
x0  0x2
(gdb) info registers x1
x1  0x55007fff38
(gdb) info registers x29
x29 0x55007ffd80
(gdb) info registers x30
x30 0x4007b4
(gdb) info registers sp
sp  0x55007ffd50
```
nothing has changed except the value of our stack-pointer, which has decreased by `0x30` or `48`. This means the command has made room on the stack for 48 bytes. We can look at our newborn stackframe by running:

```
(gdb) x/12x 0x55007ffd50
0x55007ffd50:   0x007ffd80  0x00000055  0x004007b4  0x00000000
0x55007ffd60:   0x007ffd80  0x00000055  0x0040077c  0x00000000
0x55007ffd70:   0x00000002  0x00000000  0x0047d52a  0x00000000
```

So `stp x29, x30, [sp, #-48]!` translates to decrease `sp` by `48` and store `x29` between the new value of `sp`and `sp+8` and `x30` between `sp+8` and `sp+16`.
We can clearly see the values of our registers `x29` and `x30` as well, at the bottom of our stack.

x0 contains argc (in this case `0x2`), x1 contains a pointer to memory from where to retreive the actual command line args.

## Notes

Next some general points about the ARM architecure and the instructions used in this example. We see a lot of `x0`, `x1`, ..., `x30` and so on. These are (according to the invitingly concise 11952 page ARM Architecture Reference Manual https://developer.arm.com/documentation/ddi0487/latest) the 64 bit general purpose registers of the processor. A register is essentially a small bit of memory inside the processor which can store data while the processor is working with it. These are baked into the CPU and can be accessed without addressing, which makes using them much faster than using RAM. A good overview of how a register wirks can be found in Ben Eater's beautiful series on building a gigantic 8-bit breadboard CPU https://www.youtube.com/watch?v=QzWW-CBugZo&t=5s. There are also some `w0` and `w1`, which are the 32 bit general purpose registers, which is a noce way of saying each `wN` is just the first 32 bits of the respective `xN`. so if `x0` holds the (hex)-value afafafafc4c4c4c4 then `w0` is just c4c4c4c4.

We also see `sp` a lot, which is the stack pointer, which keeps track of where exactly we are in RAM. A good intuition on the stack pointer and the stack in general is shown in this video https://www.youtube.com/watch?v=xBjQVxVxOxc (again by Ben Eater, not sure if to understand it you need to watch the entire series, sry). Another great resource is this video https://www.youtube.com/watch?v=7fezHk7nmzY, detailing the memory management of ARM CPUs specifically, introducing the concept of stack frames.

We can go through the code line by line (starting with the `main`-function in line `31`) to see what it does:



Resources:  
https://stackoverflow.com/questions/64638627/explain-arm64-instruction-stp
https://adrianstoll.com/post/working-with-64-bit-arm-binaries-on-x86-64-ubuntu/