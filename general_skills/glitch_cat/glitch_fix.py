flag_enc = chr(0x39) + chr(0x63) + chr(0x34) + chr(0x32) + chr(0x61) + chr(0x34) + chr(0x35) + chr(0x64)

flag = "picoCTF{gl17ch_m3_n07_" + str(flag_enc) +"}"

print(flag)