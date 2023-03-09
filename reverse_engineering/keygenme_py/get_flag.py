import hashlib

# the string to be hashed
string_binary = b"FRASER"

# beginning of the flag from the code
static_part = "picoCTF{1n_7h3_|<3y_of_"

# calculate the hash
hash = hashlib.sha256(string_binary).hexdigest()

# the indexing as done in the check key function of the code
locations = [4, 5, 3, 6, 2, 7, 1, 8]

# indexing the hash and joining the elements into a string
dynamic_part = "".join([hash[loc] for loc in locations])

# print the flag with a } in the end
print(static_part + dynamic_part + "}")