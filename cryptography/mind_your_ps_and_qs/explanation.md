The challenge proides us with a message `m` that has been in the form of an RSA-ciphertext `c` and the respective public key `(n , e)`. We know from RSA encryption rules that to encrypt the message we use 

```
c = m^e mod n
```

`n` is supposed to be the product of two large prime numbers `p` and `q` (hence the challenge's name).

The challenge suggests that `n` may be chosen too small a number to provide adequate encryption. To decrypt we need to find `d` the modular multiplicative inverse of `e`, as this will allow us to decrypt the message using
```
m = c^d mod n
```

The first step in the decrytion process is to factor `n` into it's prime factor constituents.

There are online integer factorization tools like https://www.alpertron.com.ar/ECM.HTM that can do the trick in about twelve minutes. Another way would be to use http://factordb.com/, which is a databse containing previously factorzed integers for RSA decryption. The result is the following

n = 1311 097532 562595 991877 980619 849724 606784 164430 105441 327897 358800 116889 057763 413423 (82 digits) 

p = 1955 175890 537890 492055 221842 734816 092141 (40 digits) 
q = 670577 792467 509699 665091 201633 524389 157003 (42 digits)
we can calculate the Euler Totient function from this 
```
picoCTF{sma11_N_n0_g0od_13686679}
```

https://en.wikipedia.org/wiki/RSA_(cryptosystem)
https://en.wikipedia.org/wiki/Integer_factorization
https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm  
https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
