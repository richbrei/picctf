# Strings it

## Description
Can you find the flag in `file` without running it?

## Solution
Run
```
wget https://jupiter.challenges.picoctf.org/static/94d00153b0057d37da225ee79a846c62/strings
```
to retreive the file called `strings`. Then execute

```
strings strings | grep pico
```
To get the flag:
```
picoCTF{5tRIng5_1T_d66c7bb7}
```