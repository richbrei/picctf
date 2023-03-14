# Description

We get a file called `chall.S` which is an ARMv8 Assembly program.

The solution to the puzzle is the number this program returns with arguments 266134863 and 1592237099? 

The flag will contain this number in format: picoCTF{XXXXXXXX} -> (hex, lowercase, no 0x, and 32 bits. ex. 5614267 would be picoCTF{0055aabb})

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

The last step is to install the qemu user-mode emulator to run statícally linked binaries using the command:

```
sudo apt install qemu-user-static
```

This works like a charm, as it runs in the background and acts if you are about to execute a binary destined for a different processor architecture. if we check on our binary we can see that it is ARMv8 or aarch64:

```
$ file chall
chall: ELF 64-bit LSB executable, ARM aarch64, version 1 (GNU/Linux), statically linked, BuildID[sha1]=01f9fa0c8ea99099d48e622391bbf3269ff150e5, for GNU/Linux 3.7.0, not stripped
```

However if we execute the file as we would execute any proper x86 binary we get:

```
$ ./chall
qemu: uncaught target signal 11 (Segmentation fault) - core dumped
Segmentation fault
```

Told you it works like charm... So actually what's wrong is that the program requires command line arguments or it will crash. If we try a couple, we see that it is working:

```
./chall 0 0
Result: 0
./chall 0 1
Result: 1
./chall 0 12
Result: 12
./chall 1 12
Result: 12
```

We see that the program simply throws back the second command line argument at us, regardless of the first one. With this information we could already complete the chalenge, however maybe it is interesting to look at the code to learn something about ARM Assembly. So let's waste some time:

First some general points about the ARM architecure and the instructions used in this example. We see a lot of `x0`, `x1`, ..., `x30` and so on. These are (according to the invitingly concise 11952 page ARM Architecture Reference Manual https://developer.arm.com/documentation/ddi0487/latest) the 64 bit general purpose registers of the processor. A register is essentially a small bit of memory inside the processor which can store data while the processor is working with it. These are baked into the CPU and can be accessed without addressing, which makes using them much faster than using RAM. A good overview of how a register wirks can be found in Ben Eater's beautiful series on building a gigantic 8-bit breadboard CPU https://www.youtube.com/watch?v=QzWW-CBugZo&t=5s. There are also some `w0` and `w1`, which are the 32 bit general purpose registers, which is a noce way of saying each `wN` is just the first 32 bits of the respective `xN`. so if `x0` holds the (hex)-value afafafafc4c4c4c4 then `w0` is just c4c4c4c4.

We also see `sp` a lot, which is the stack pointer, which keeps track of where exactly we are in RAM. A good intuation on the stack pointer and the stack in general is shown in this video https://www.youtube.com/watch?v=xBjQVxVxOxc (again by Ben Eater, not sure if to understand it you need to watch the entire series, sry)

We can go through the code line by line (starting with the `main`-function in line `31`) to see what it does:

```
stp	x29, x30, [sp, -48]!
```

`stp` stands for store pair and stores the values in the two registers `x29`and `x30` in the processor into the memory location passed as the third argument in the instruction. This third argument means thatthe stacl pointer should be decremented by 48 and the values should be stored at this new address. 

Resources:  
https://stackoverflow.com/questions/64638627/explain-arm64-instruction-stp