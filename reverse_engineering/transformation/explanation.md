# Transformation

we cet a file called `enc` which when flooking at it reveals to be:

```
$ file enc
enc: Unicode text, UTF-8 text, with no line terminators

$ cat enc
灩捯䍔䙻ㄶ形楴獟楮獴㌴摟潦弸彤㔲挶戹㍽
```

we are also provided a python function that seems to be related to this file.

```
''.join([chr((ord(flag[i]) << 8) + ord(flag[i + 1])) for i in range(0, len(flag), 2)])
```

It is the function used to encode the flag which supposedly is a normal string so 1 byte = 8 bit -> 1 character. What the encoding function does is take every even (starting at 0) byte of the flag and shifts it left by 8 bits and adds every odd byte to it which turns e.g. the first two bytes into:

```
flag[0] = "p" 
flag[1] = "i" 

ord(flag[0]) = 112 
ord(flag[1]) = 105

format(112, '#010b') = '0b01110000'
format(105, '#010b') = '0b01101001'

(112<<8)+105 = 28777

format(28777, '#010b') = '0b111000001101001'

chr(28777) = '灩'
```

So to decode it we simply need to reverse the process by for each element in the encoded flag we take the first 8 bit (which we get by just shifting it 8 bits right) as one character and the second 8 bit (which we get by AND-ing the element with 255 which is 0b0000000011111111) as the next character:

```
flag[0] = encoded_flag[0] >> 8
flag[1] = encoded_flag[0] & 255
```