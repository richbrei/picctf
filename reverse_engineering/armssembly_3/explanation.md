# ARMssembly 3

we can again assemble our program and run it to get the correct answer immediately:

```
aarch64-linux-gnu-as -o chall_3.o chall_3.S
aarch64-linux-gnu-gcc -static -o chall_3 chall_3.o
qemu-aarch64 ./chall_3 1048110976
Result: 48
```

So the flag is 

```
picoCTF{00000030}
```

As before the program pushes argv[1] through <atoi> and passes the result to <func1>. <func1> has a couple of branches including one branch to <func2>. <func2> is rather simple, taking an input and adding 3 to it. We can write this into out C program.

```
int func2(int input){

    int result = input + 3;

    return(result);
}
```

<func1> is a bit more complicated. It initializes a value with 0 and then branches t0 label .L2. There is comares our command line argument to 0. If this is the case it simply loads the zero initialized value into `w0` returns to <main> and <printf>s out said zero.

If the command line argument is not equal to zero the function branches to label .L4. We can see that at .L4 it `and`s our command line argument with 1 and compares it to zero. If this is the case it jumps to .L3, where we load our command line argument into `w0` from the stack and right shift is by 1 using the `lsr` instruction which stands for logical shift right. Then we push it back to the stack.

```
ldr	w0, [x29, 28]
lsr	w0, w0, 1
str	w0, [x29, 28]
```

Then we go back to loading our now right shifted command line argument back from the stack and comparing it to 0 again, jumping back to .L4 if it is non-zero. So we are in a loop right-shifting out command line argument by one bit each iteration. If the lowest bit is zero, nothing else happens. If it is one however we do not branch straight to .L3 but call we call <func2> on our zero initialized valriable, incrementing it by 3. So our program counts the number of ones in the binary representation of our integer command line argument and prints that number multiplied by 3. 

Our input represented in binary looks as follows:
```
1048110976 = 0011 1110 0111 1000 1110 0111 1000 0000
```
There are 16 ones in this integer which would make the result 48 which indeed it is.

We can again see that our C representation of the assembly get's pretty close to the original .S file when compiled (see chall_3.c and chall_test.c).