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

The maximum value a signed integer can hold is `2147483647` or `2^15 - 1`, in binary this would be 

```
0111 1111 1111 1111 1111 1111 1111 1111
```

If we add one to this number this will become

```
1000 0000 0000 0000 0000 0000 0000 0000
```

Which is a negative number according to signed integer rules.