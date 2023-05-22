# Bases

## Description
What does this bDNhcm5fdGgzX3IwcDM1 mean? I think it has something to do with bases.

## Solution
What we have here is a string in base64 encoding. Base64 can be thought of as similar to hexadecimal but encoding 6 bytes rather than for bytes in each digit. Rather than using just numbers 0-9 and letters A-F to encode numbers from 0-15 it uses all lower case and uppercase letters, numbers from 0-9 and `+` and `/` to encode numbers from 0-63.

A detailed explanation including a decoding/encoding table can be found here: https://en.wikipedia.org/wiki/Base64

We can decode it using interactive python:

```
$ python3
>>> import base64
>>> encoded = "bDNhcm5fdGgzX3IwcDM1"
>>> base64.b64decode(encoded)
b'l3arn_th3_r0p35'
>>> exit()
```