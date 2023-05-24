# flag_shop

## Description

There's a flag shop selling stuff, can you buy a flag? `Source`. Connect with `nc jupiter.challenges.picoctf.org 44566`.

## Explanation

The program allows us to buy cheap flags for 900$ of which we can afford one with our starting account balance of 1100$. When asked how many of these cheap flags we want the value is stored into a signed integer, which we can exploit to make more money. We can use the test program to illustrate what happens:

```
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

Binary subtraction in machines works similarly to this line of thinking, you take the subtrahend, "invert" it and then add it to the minuend using the same hardware circuit that you would use for addition. The inversion part is achieved by using two's complement.