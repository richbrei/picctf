import sys

flag_file = sys.argv[1]

def encode(flag):
    return ''.join([chr((ord(flag[i]) << 8) + ord(flag[i + 1])) for i in range(0, len(flag), 2)])

def decode(encoded_flag):
    out = []
    for el in encoded_flag:
        out.append((chr(ord(el) >> 8)))
        out.append(chr(ord(el) & 255))
    return ''.join(out)

def main():
    with open(flag_file,"r")as f:
        encoded_flag = f.read()
        print(f"   encoded flag: {encoded_flag}")
        print(f"   decoded flag: {decode(encoded_flag)}")
        print(f"re-encoded flag: {encode(decode(encoded_flag))}")
        

if __name__ =="__main__":
    main()
    