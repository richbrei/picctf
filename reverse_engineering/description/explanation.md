# Description

We get a file called `chall.S` which is an ARMv8 Assembly program.

The solution to the puzzle is the number this program returns with arguments 266134863 and 1592237099? 

The flag will contain this number in format: picoCTF{XXXXXXXX} -> (hex, lowercase, no 0x, and 32 bits. ex. 5614267 would be picoCTF{0055aabb})

The first intuition would be to just compile and run the program with the required inputs. This is however not a trivial task. As it is ARMv8 assembly it won't run on most normal laptop or desktop machines as they are typically x86 processor architectures. A Raspberry Pi (the ARM chip that might be lying around some peoples houses) it is not certain that this will compile, on my Raspberry Pi 4B the assembler threw an error as i am using the 32-bit version of the OS. I would assume that this is by design so that one really has to read the code and understand what it is doing.

We can go through the code line by line (starting with the `main`-function in line `31`) to see what it does:

```
stp	x29, x30, [sp, -48]!
```

`stp` stands for store pair and stores two registers in the processor into memory. In this case these registers are `x29` which is the frame pointer, pointing to the 