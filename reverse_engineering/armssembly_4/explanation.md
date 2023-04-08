# ARMssembly 4

The final one of the armssembly challenges can be again approached forst by cross-compilation and emulation

```
aarch64-linux-gnu-as -o chall_4.o chall_4.S
aarch64-linux-gnu-gcc -static -o chall_4 chall_4.o
qemu-aarch64 ./chall_4 3251372985
Result: 3251373100
```

So the flag is 

```
picoCTF{c1cc042c}
```

Reversing the functionality of the code should by now be old socks. However they upped the amount of instructions significantly and started calling not 2 but 8 different functions beyond main... So we need to reverse them all. <main> starts out pretty standard by transforming our argv[1] insto an integer and passing it to <func1>. 

Let's first look at each function individually to determine what they do.

<func1> compares it's input to 100. If the input is less it calls <func3> on the input. If it is more it adds 100 to the input and calls <func2> on it.

<func2> compares it's input to 499. If the input is higher than that it adds 13 to the input and calls <func5> on it. If not, it subtracts 86 from the input and calls <func4> on it.

<func3> is a wrapper for <func7>

<func4> creates a vaiable of value `17`and calls <func1> on it. Then it simply returns it's input

<func5> is a wrapper for <func8>

<func6> is never called...

<func7> compares the input to 100. if the input is smaller than 100 it returns 7, if it is bigger it returns the input value.

<func8> takes an input and adds 2 to it.

Our input is `3251372985` which is larger than `100` so it will be added with `100` and passed into <func2>. As it is larger than `499`as well it will be added with `13` and passed into <func5> which passes it straight into <func8>. THere it is added by `2`and returned. So in total we have added `100 + 13 + 2 = 115` to our value which indeed is the difference between our input and output in the test run above.

For all input values below `100` the result will always be `7` as we call <func3> in this case which calls <func7> which returns `7` for all inputs below `100`.

For all inputs between `101` and `399` will always be passed through <func2> and <func4> where it is first added with `100`and then subtracted with `86` which results in a `+14` which is indeed the result we get. 

Everything equal and above `400` will follow the chain of our original input value, being added with `100`, passed to <func2>, there being added with `13`, passed to <func5> and from there straight to <func8>, where it is added with `2` and then returned. This totals at a `+115`.

So overall the challenge was more about obfuscation than about clever code.

We can compile our assumed C code into assembly and compare it to the original.
```
aarch64-linux-gnu-gcc -S -static -o chall_test.S chall_4.c
```
We see that it is familiar though there are some obvious differences.