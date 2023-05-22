import hashlib

pos_pw_list = open("dictionary.txt","r").read().split("\n")

def hash_pw(pw_str):
    pw_bytes = bytearray()
    pw_bytes.extend(pw_str.encode())
    m = hashlib.md5()
    m.update(pw_bytes)
    return m.digest()

correct_pw_hash = open('level5.hash.bin', 'rb').read()

for pw in pos_pw_list:
    if hash_pw(pw) == correct_pw_hash:
        print(pw)
