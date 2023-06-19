# These have been provided with the challenge
ciphertext = 861270243527190895777142537838333832920579264010533029282104230006461420086153423
n = 1311097532562595991877980619849724606784164430105441327897358800116889057763413423
e = 65537

# This is the factization result obtained
p = 1955175890537890492055221842734816092141
q = 670577792467509699665091201633524389157003

assert p*q == n

# calculating the Euler totient function
phi = (p-1)*(q-1)


def gcd(a, b):
    # greatest euclidian algorithm to determine the greatest common divisor of a and b
    if a == 0:
        return (b, 0, 1)
    g, y, x = gcd(b%a,a)
    return (g, x - (b//a) * y, y)

def mmi(a, m):
    # modular multiplicative inverse
    g, x, y = gcd(a, m)
    if g != 1:
        raise Exception('No modular inverse')
    return x%m

d = mmi(e, phi)

message = pow(ciphertext, d, n)

print(bytearray.fromhex(hex(message)[2:]).decode())
