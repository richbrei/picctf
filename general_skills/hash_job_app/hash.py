import hashlib
import socket
import time

HOST = "saturn.picoctf.net"
PORT = 49697

prompt_msg = "Please md5 hash the text between quotes, excluding the quotes:"

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    s.connect((HOST, PORT))
    for _ in range(3):
        prompt = s.recv(4096).decode()
        target = [t.split("\'")[-2] for t in prompt.split("\n") if prompt_msg in t][0]
        print(f"received target: {target}")
        hash = hashlib.md5(target.encode()).hexdigest() +"\n"
        print(f"sending md5 hash: {hash}")
        s.sendall(hash.encode())
        data = s.recv(len(hash)) 
        time.sleep(.5)
    data = s.recv(1024) 

    print("Your flag is: ", data.decode().split("\n")[-2])