# keygenme-py

We get a python file called `keygenme_trial.py` without comment.

looking at the file we can see that it contains the flag in plain sight quite at the top:

```
key_part_static1_trial = "picoCTF{1n_7h3_|<3y_of_"
key_part_dynamic1_trial = "xxxxxxxx"
key_part_static2_trial = "}"
key_full_template_trial = key_part_static1_trial + key_part_dynamic1_trial + key_part_static2_trial
```

Which suggests that the flag is something like:

```
picoCTF{1n_7h3_|<3y_of_xxxxxxxx}
```

Where it seems like the `x` characters are placeholders. We can look through the file and discard the overhead. When executed the code seems to execute a function called `ui_flow` which itself forst executes a function called `intro_trial` which is just printing and therefore can be discarded, and then calles a function called `menu_trial` in an infinite loop.

`menu_trial` asks for user input and depending on it selects a different function to execute. There is one function checking whether the input is in the allowed range, chich can also be discarded. 

If the input is `a` the function `estimate_burn` is executed, which isn't doing anything relevant so we can discard that, too including the valiable `star_db_trial` which is not called from anywhere else. 

If the input is `b` the function `locked_estimate_vector` is executed, which only prints and therefor may be discarded as well.

If the input is `d` the `menu_trial` function will terminate itself.

If the input is `c` we get to the meat of the flag extraction. First a function called `check_license` is called which will take user input and check it using the `check_key` function. If the key is correct it will call the function `decrypt full_version` which itself will feed a base64 encoding of the key into a Fernet-cipher obeject and uses this to decrypt a large string which is stored in the within the code and writes the results into a separate file called `keygenme.py` which suggests that the large string is encrypted python code.

The `check_key` function will essentially give us the flag. It will first check the 23 characters of the user input key againt the `key_part_static1_trial`. Then it will ckeck the following characters against characters in the SHA256 hash of the word FRASER's hexdigest. We can reproduce this behaviour as has been done in `get_flag.py`

The flag is:
```
picoCTF{1n_7h3_|<3y_of_ac73dc29}
```

We can use the flag to decrypt the full version of the keygenme game.